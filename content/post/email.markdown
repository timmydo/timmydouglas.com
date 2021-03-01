---
date: 2021-02-28
tags:
- email
- exim
title: "So you want to run your own mail server..."
---

This is a question a lot of people with their own domain name or Unix
experience might ask at some point, and you'll probably get a lot of
different answers.

This [blog
post by Lars Ingebrigtsen](https://lars.ingebrigtsen.no/2020/03/25/so-you-want-to-run-your-own-mail-server/)
covers a lot of it, and is the source of inspiration for this blog
post.

I have wanted to do this for a while, but it seemed like a hassle (if
it seems like a hassle, then that's probably not a good sign for me
doing this...). I pay for [tuffmail](https://www.tuffmail.com/) and
haven't had any problems with them.


Some enthusiast IMAP/email providers have limits on amounts of
traffic, and I subscribe to some higher volume email mailing lists, so
I thought it'd be worth looking at what it'd be like to host email
myself. I basically got a "hello world" working with the approach
below.

## Working with a 'smarthost'

What if you only needed to solve half of the hosting problem? One
tricky part of hosting your own mail server is sending email without
it ending up in everyone's spam folder. What if you get a free or
cheap provider for the handful of emails you send, and then just focus
on hosting the receiving part? You can find a free-tier plan from
[SendGrid](https://sendgrid.com/),
or [mailgun](https://www.mailgun.com/) for sending? I'll go into more
details below.


## Exim

The process starts with installing a MTA. I'm using
[Exim](https://www.exim.org/), since that was used in Lars's original
tutorial. I already have a server used to host this blog, and it
already has Let's Encrypt certificates installed on it, so I'm going
to reuse it for email. Normally it isn't a great idea to reuse a
server like this, and given [Exim's
history](https://www.cvedetails.com/vulnerability-list/vendor_id-10919/product_id-19563/Exim-Exim.html),
it's not something I'd do unless I was only hosting a blog backed by a
public git repository...

## Scripting

I modified Lars's `make-mta.sh` as a starting point. It sets up a
basic firewall, mta-sts, apt installs `exim4-daemon-heavy clamav spamassassin
clamav-daemon sasl2-bin bind9`, sets up the config, installs dovecot,
and prints some DNS settings. Unfortunately, it had some issues
parsing the `$host` and `$domain` variables, so I needed to go in and
clean things up. I might have lost spamassassin and clamav during the
config file regeneration.

## SMTP MTA Strict Transport Security (MTA-STS)

MTA-STS is like HSTS for SMTP hosts. Since the SMTP RFC allows servers
to deny STARTTLS, an attacker could intercept the connection to the
SMTP server and keep the connection downgraded to intercept
emails. MTA-STS is supposed to prevent this. Basically I have to host
a file at
[https://mta-sts.mail.timmydouglas.com/.well-known/mta-sts.txt](https://mta-sts.mail.timmydouglas.com/.well-known/mta-sts.txt)
that contains something like:

```
version: STSv1
mode: enforce
mx: timmydouglas.com
max_age: 1209600
```
then create a DNS record:

```
_mta-sts.mail.timmydouglas.com.  IN TXT "v=STSv1; id=20160831085700Z;"
```

The id there is basically for cache busting the well known text file.

I was able to configure this manually by creating
`/etc/apache2/sites-enabled/mta-sts.conf`:


```txt
<VirtualHost *:443>
        ServerName mta-sts.mail.timmydouglas.com
        DocumentRoot /var/www/mta-sts
        SSLCertificateFile /etc/letsencrypt/live/mail.timmydouglas.com/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/mail.timmydouglas.com/privkey.pem
</VirtualHost>
```

Run certbot, tell it you want a cert for mta-sts.mail.timmydouglas.com,
then it will modify the file for you to:

```txt
<VirtualHost *:443>
        ServerName mta-sts.mail.timmydouglas.com
        DocumentRoot /var/www/mta-sts
        SSLCertificateFile /etc/letsencrypt/live/mta-sts.mail.timmydouglas.com/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/mta-sts.mail.timmydouglas.com/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
```

[RFC8461 on MTA-STS](https://tools.ietf.org/html/rfc8461)


[More info on Hardenize
website. Has a verification tool](https://www.hardenize.com/blog/mta-sts)


## Exim

The debian package of exim4 is configured in a file
`/etc/exim4/update-exim4.conf.conf` and it generates the exim config
file when you run `/usr/sbin/update-exim4.conf` (weird?)

If you want an interactive configuration experience, you can run
`dpkg-reconfigure exim4-config`

My config looked like this:

```text
dc_eximconfig_configtype='local'
dc_other_hostnames='timmydouglas.com;mail.timmydouglas.com'
dc_local_interfaces=''
dc_readhost='mail.timmydouglas.com'
dc_relay_domains=''
dc_minimaldns='false'
dc_relay_nets=''
dc_smarthost=''
CFILEMODE='644'
dc_use_split_config='true'
dc_hide_mailname='true'
dc_mailname_in_oh='true'
dc_localdelivery='maildir_home'
```

I'm using local because I want to accept incoming mail but not send
email anywhere.

## DNS

I have these set up to receive mail.

```text
mail.timmydouglas.com.	3600	IN	MX	10 timmydouglas.com.
mta-sts.mail.timmydouglas.com.	3600	IN	CNAME	timmydouglas.com.
_mta-sts.mail.timmydouglas.com.  IN TXT "v=STSv1; id=20160831085700Z;"
timmydouglas.com.	900	IN	A	52.156.153.159
```

So when an email is sent to `timmy@mail.timmydouglas.com` it will
look up the MX record, follow the CNAME and connect to the IP, ideally
using the MTA-STS to ensure it goes to a secure port, SMTPS/465. Exim
will write it to ~timmy/Maildir, which dovecot reads when serving them
through IMAP.


## Dovecot

`apt install dovecot-imapd` then edit the ssl certs in
/etc/dovecot/conf.d/10-ssl.conf:


```text
ssl = yes
ssl_cert = </etc/letsencrypt/live/timmydouglas.com/fullchain.pem
ssl_key = </etc/letsencrypt/live/timmydouglas.com/privkey.pem
```

Also set the mail_location in conf.d/10-mail.conf:

```text
mail_location = maildir:~/Maildir
```


## Offlineimap

To receive mail from Dovecot, I used this `~/.config/offlineimap/config`:

```ini
[general]
accounts = mailtimmydouglascom
pythonfile = ~/.config/offlineimap/helpers.py

[Account mailtimmydouglascom]
localrepository = mailtimmydouglascom-local
remoterepository = mailtimmydouglascom-remote

[Repository mailtimmydouglascom-local]
type = Maildir
localfolders = ~/mail/mailtimmydouglascom

[Repository mailtimmydouglascom-remote]
type = IMAP
remotehost = timmydouglas.com
remoteuser = timmy
remotepasseval = get_pass('mailtimmydouglascom')
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
ssl = yes
```

Then run `offlineimap -o -a mailtimmydouglascom -u basic` and the mail
should be put in `~/mail/mailtimmydouglascom`.

I want to try mbsync/isync someday because I hear it's faster.

## Sending with SendGrid

So, I'm not sure this is the ideal scenario--the service seems to be
set up for marketing teams to send a bunch of marketing emails. I was
able to create an account, add domain authentication by adding 3 CNAME
records to my DNS, add then by adding a [SMTP
relay](https://app.sendgrid.com/guide/integrate).

I added the relay to my authinfo.gpg:

```text
machine smtp.sendgrid.net login apikey password your-password-here
```

Then editing my Emacs config:

```lisp
(setq send-mail-function    'smtpmail-send-it
	      smtpmail-smtp-server  "smtp.sendgrid.net"
          smtpmail-stream-type  'ssl
          smtpmail-smtp-service 465)
```

I was able to send (through SendGrid) and receive (through
Exim/Dovecot) an email from Gmail successfully.


I probably need to think about this approach some more. I'm not sure
if I would hit some gotchas by using different methods for sending and
receiving for the same mail domain. Honestly, it might just be easier
to send email using Exim than to have a separate smarthost. I didn't
even go into setting up the SPF, DKIM, and DMARC records (which
probably aren't that bad...). But for now, I'll continue paying for
email.


