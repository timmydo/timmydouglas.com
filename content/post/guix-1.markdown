---
date: 2020-12-21
tags:
- scheme
- Lisp
- Guix
title: "GNU Guix"
---

Today I spent the better part of the day installing [GNU
Guix](https://guix.gnu.org/) System onto one of my laptops. There are
a couple of ways to run Guix: you can install just the package manager
on a foreign Linux distribution, or you can install the Guix System,
which is its own Linux (or GNU/Hurd) distribution. I originally
investigated putting Guix System on my Raspberry Pi, but after
searching for some instructions, I found that I would probably have
been in for a day of pain. The Guix System
distribution only includes free software and Linux kernels without
binary blobs, so it was a safer bet to go with some common x64
hardware. I have been running the package manager on my machine for a
couple of weeks and was toying with the idea of having a bare bones
Linux distro with just the package manager on top, but it seems that
you miss out on all the system-level features when going that route.

Why Guix? Here are a couple of reasons:

  - Declarative system configuration (think of putting all your system
    configuration into a text file and being able to version that in
    git)
  - Transactional upgrades and roll-backs (even choose an older
    system version from the GRUB menu!).
  - Installed apps backed by read-only blob store and
    symlinks. Deduplication of artifacts.
  - Can create profiles (group packages together), using isolated
    environments. Environments can be exported to tar archives/docker.
  - Reproducible builds, build provenance features.
  - Single underlying configuration language that is a full-featured
    programming language (Scheme on the Guile implementation)
  - Freedom respecting


On the downside, it may take a little longer than something
like Ubuntu due to it being targeted towards more technical users and
the lack of information on the internet on how to solve problems. If
you are using hardware that's not supported, you might need to go
through some extra steps to get a custom kernel. Given you probably
want to do it the Guix way rather than `git clone
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git &&
 ... && make install`, it will take a little longer to get set up, but
 once you have, you'll be in a better place for upgrading. I think the
 value proposition is about spending a little more time to set up your
 system so that upgrades and bootstrapping a new system can be easier.
 
 On a traditional Linux distribution, the user is going to edit a
 bunch of config files all over the place, and if you were to
 reinstall, you'd take quite a bit of time getting things back to
 where they were. Having your dot files in a git repo makes it a lot
 quicker, but there is still a lot of stuff stored outside of the dot
 files.
 
 Let's take a look at some code. This is what my system configuration
 file looks like shortly after the install. It was mostly generated
 by the graphical installer which made the install a breeze:
 
 ```scheme
(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "timmy-t430s")
  (users (cons* (user-account
                  (name "timmy")
                  (comment "Timmy")
                  (group "users")
		  (shell "/home/timmy/.guix-profile/bin/zsh")
                  (home-directory "/home/timmy")
                  (supplementary-groups
				    ;; added "input" for sway
                    '("wheel" "netdev" "audio" "video" "input")))
                %base-user-accounts))
  (packages
    (append
     (map specification->package
	  '("nss-certs"
	    "alacritty"
	    "emacs-next-pgtk"
	    "git"
	    "notmuch"
	    "icecat"
	    "zsh"
	    "i3status"
	    "sway"
	    "curl"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service network-manager-service-type)
            (service wpa-supplicant-service-type))
      %base-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "3a8b19bd-f826-4d3f-8c48-521d748108a6")))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "0FEC-651D" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "3565f88e-5cb9-4369-ba31-f69b74fb9bff"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
 ```

I don't know if it ever detected wireless so I ended up building my
first ethernet cable as a part of the project.

I run the sway wayland compositor with mostly just Emacs, alacritty,
and a web browser. Sway had some issues starting:

  - "XDG_RUNTIME_DIR is not set in the environment. Aborting." -- This
    wasn't set up
  - Locking up after "User has no sessions Couldn't find an active session or a greeter session" [https://github.com/swaywm/sway/issues/3975](https://github.com/swaywm/sway/issues/3975)

 so I ran it with:

```sh
WLR_DRM_DEVICES=/dev/dri/card0 XDG_RUNTIME_DIR=~/.tmp sway -d 2> ~/.tmp/sway.log
```

and it seemed to start fine after that (and I added my user to the
input group).

One other change is that Guix uses GNU Shepherd instead of systemd. I
like systemd, but I guess I have to appreciate that Shepherd can be
programmed using scheme configuration files instead of another custom
ini/toml format. Although I sort of wonder what kind of isolation
there is between the code you write in the configuration and what the
init process is running.

I created `/home/timmy/.config/shepherd` with the contents:

```scheme
(use-modules (shepherd service)
	     (ice-9 match))

(define-syntax-rule (with-fork body ...)
  (match (primitive-fork)
    (0 (begin body ...))
    (pid pid)))

(define (run-command command)
  (zero? (status:exit-val (apply system* command))))

(register-services

 (make <service>
        #:provides '(notmuch)
        #:requires '()
        #:start
	(lambda args
          (with-fork
           (while #t
            (system* "/home/timmy/.config/notmuch/new.sh")
            (sleep 100))))
        #:stop (make-kill-destructor))


  (make <service>
    #:provides '(emacsd)
    #:requires '()
    #:start (lambda _ (run-command '("emacs" "--daemon")))
    #:environment-variables
    (list
     "HOME=/home/timmy"
     "SSH_AUTH_SOCK=/run/user/1000/keyring/ssh")
    #:stop (lambda _ (not (run-command '("emacsclient" "--eval" "(kill-emacs)")))))


  )

(action 'shepherd 'daemonize)
```


Then you can run shepherd as a user. Then run `herd start` on your
services.

I'll need to spend some more time with Guix before I have a fully
formed opinion about it, but I like both Scheme and using desired
state configuration, so the chances are good I'll grow to like it. I
think one good application would be home router config, so I'll need
to look into what it'd take to use it on the Raspberry Pi.
