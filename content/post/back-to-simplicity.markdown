---
date: 2024-03-24
tags:
- alpine
- simplicity
title: "Passkeys and a Simpler Operating System"
---

I'm trying to write something every month but I'm having
trouble coming up with original ideas for these journal posts. Earlier
this week I bought a yubikey fido edition and played around with
passkeys. Passkeys are a passwordless approach to logging into
accounts. I think of it as a certificate-based authentication with
some improvements to usability. Unfortunately it seems that the
web-part of the design is based on Javascript APIs--I was hoping there
would be an approach that didn't require Javascript to run on the
client. I assume that it must've been the easiest way to get browser
support though.

On my GNU Guix machine, I was able to get it working with:
```
(use-package-modules security-token)

;; user definition:
(supplementary-groups
;; snip
    '(... "plugdev"))

;; services
  (services
    (append
     (list 
;; snip
	   (udev-rules-service 'fido2 libfido2 #:groups '("plugdev"))
	   )))
	   
$ guix install python-yubikey-manager
```

Firefox nightly was able to use it after I set up a PIN. I was also
able to get Firefox's bitwarden extension (which I only installed for
a quick experiment) to create a passkey. I can't say what the long
term experience is like, and there don't seem to be many supported
websites for this technology. Given usability improvements to password
managers, it will be interesting to see how much adoption this gets
outside of major tech-company websites. There does seem to be some
security benefit to having your credentials on a special hardware
device like a yubikey.


The other thing I wanted to write about was my decision to install
Alpine Linux on an old laptop I had Guix installed on. I was getting
tired of the complexity of editing the system configuration in a
Scheme file and waiting an hour for the world to reconcile every time
I wanted to update. Most of that is probably compiling a custom linux
kernel because Guix only has binary substitutes for the de-blobbed
one. But running that would be a non-starter on a laptop that needs
wifi to connect. I broke my login shell during an update (it was a
symlink to /home/timmy/.guix-profile/bin/zsh), which got messed up (I
can't remember what I was doing), and it wasn't as trivial as it
should have been to fix it. There is just too much complexity going on
under the covers and I decided that I want a system that doesn't have
magic going on, even if it comes at the expense of some nifty
features. The alpine package manager is straight to the point and
super fast in comparison. OpenRC is easier to understand than GNU
Shepherd, and I can set up a Sway-based desktop environment without
coming up with a bunch of custom service config to tie together seat
providers, dbus, etc. I'm not sure I'd really be able to re-use
/etc/config.scm files across different computers anyways, so all I
need is a couple of dotfile-equivalents for setting up a new computer.
I created an `org/alpine` directory with some things like this:


setup.txt
```
vi /etc/apk/repositories
setup-devd udev
rc-service add iwd default
iwctl
vi /etc/network/interfaces
rc-update add seatd
vi /etc/profile.d/xdg.sh
vi /etc/sway/config
vi /usr/local/bin/sw

```

xdg.sh
```
#!/bin/sh

if test -z "${XDG_RUNTIME_DIR}"; then
	export XDG_RUNTIME_DIR=/tmp/$(id -u)-runtime-dir
	if ! test -d "${XDG_RUNTIME_DIR}"; then
		mkdir "${XDG_RUNTIME_DIR}"
		chmod 0700 "${XDG_RUNTIME_DIR}"
	fi
fi
```

/usr/local/bin/sw
```
#!/bin/sh
exec dbus-run-session sway
```

/etc/apk/world
```
acct
alpine-base
alsa-utils
alsaconf
busybox-mdev-openrc
chrony
dmenu
doas
dosfstools
e2fsprogs
eudev
firefox
font-awesome
font-dejavu
foot
grub-efi
iwd
linux-firmware-i915
linux-firmware-intel
linux-firmware-mediatek
linux-firmware-other
linux-firmware-rtl_bt
linux-lts
mesa-dri-gallium
networkmanager
networkmanager-tui
networkmanager-wifi
openssh
openssl
pavucontrol
pipewire
pipewire-pulse
pipewire-tools
rofi-wayland
seatd
sway
udev-init-scripts
udev-init-scripts-openrc
waybar
wireplumber
xdg-desktop-portal
xdg-desktop-portal-wlr
```

/etc/sway/config
```
# Default config for sway
#
# Copy this to ~/.config/sway/config and edit it to your liking.
#
# Read `man 5 sway` for a complete reference.

set $mod Mod4
set $left h
set $down j
set $up k
set $right l
set $term foot
set $menu rofi -show drun | xargs swaymsg exec --

exec /usr/libexec/pipewire-launcher


    bindsym $mod+Return exec $term
    bindsym $mod+Shift+q kill
    bindsym $mod+d exec $menu
    floating_modifier $mod normal
    bindsym $mod+Shift+c reload
    bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10
    # Move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.
#
# Layout stuff:
#
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle

    # Move focus to the parent container
    bindsym $mod+a focus parent
#
# Scratchpad:
#
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show
#
# Resizing containers:
#
mode "resize" {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    bindsym $left resize shrink width 10px
    bindsym $down resize grow height 10px
    bindsym $up resize shrink height 10px
    bindsym $right resize grow width 10px

    # Ditto, with arrow keys
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

#
# Status Bar:
#
# Read `man 5 sway-bar` for more information about this section.
bar {
swaybar_command waybar
}

include /etc/sway/config.d/*
```
