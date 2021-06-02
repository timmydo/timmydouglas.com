---
date: 2021-06-01
tags:
- mbsync
- isync
- offlineimap
title: "Migrating from offlineimap to mbsync/isync"
---


When I originally set up my email, I can't say I did enough research
with regards to how to pull email from IMAP and store it locally for
fast local access. I settled on offlineimap, which seemed to be pretty
popular, but it has a few issues:

- it's slow
- sometimes it gets stuck fetching mail (a couple of times I noticed
  days later that there was a hung process and a lockfile that kept
  new instances from starting)
- the current version in still on python2
- the author wants to replace it with imapfw (I think this started 5
  years ago--and I'm not sure if it has made much progress)
  
  
On the other hand, there is a package called isync with the mbsync
executable. It doesn't seem any more actively maintained, but it's
written in C and is a lot
[faster](https://people.kernel.org/mcgrof/replacing-offlineimap-with-mbsync). So
like, mcgrof from the previous blog post, I set out to replace
offlineimap with mbsync.


The config file is fairly straightforward, so I'll roughly outline
what it looks like. There weren't many examples online, so hopefully
this will help.

offlineimap:

```
[general]
accounts = mydomain
pythonfile = ~/.config/offlineimap/helpers.py

[Account mydomain]
localrepository = mydomain-local
remoterepository = mydomain-remote

[Repository mydomain-local]
type = Maildir
localfolders = ~/mail/mydomain

[Repository mydomain-remote]
type = IMAP
remotehost = your.imap.server.name
remoteuser = you@yourdomain.com
remotepasseval = get_pass('tuffmail')
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
ssl = yes

[Account mailmydomain]
localrepository = mailmydomain-local
remoterepository = mailmydomain-remote
```

mbsync:

```
# mbsync config

Create Near
SyncState *

# my mail

MaildirStore mydomain-local
Path ~/mail/mydomain/
Inbox ~/mail/mydomain/inbox
SubFolders Verbatim

IMAPStore mydomain-remote
Host your.imap.server.name
User you@yourdomain.com
PassCmd "gpg -dq ~/.password-store/tuffmail.gpg"
SSLType IMAPS

Channel mydomain-channel
Far :mydomain-remote:
Near :mydomain-local:
Patterns INBOX * !Sync*
Create Near
```

My worse is better `get-mail-loop.sh` to replace some systemd timers/units:

```sh
#!/bin/sh

set -x

while true
do
    date
    mbsync -a
    ~/bin/fetchrss.sh
    notmuchnew
    sleep 5m
done
```

I moved my old maildir away and had mbsync regenerate it. Then I had
notmuch retag everything after mbsync downloaded it all again.
