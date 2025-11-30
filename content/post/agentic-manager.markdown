---
date: 2025-11-29
tags:
- ai
title: "Becoming a Manager of AI Agents"
---

As AI agents become more competent at writing code, the less
babysitting they'll need. If you asked me what software developers
needed 5 years ago, I might have said a better IDE than VS Code. My
last blog post was about Zed, which is probably around that old. I
never really ended up using the editor after I got it working--I'm
just sort of used to emacs and feel like I don't really need a full
IDE at this point when doing software development. I feel like the
flow is now more centered around chatting with the AI agent and
reviewing/staging diffs. I'm generally using magit for the diff part,
but I'm generally using a terminal for the agent conversation part.

I'm starting to have less and less patience when AI agents ask if
they can run a command like `ls` or `sed`. I want to run them all in
YOLO mode until things start to go south, but given how little you can
trust them with executing arbitrary code, it seems like the best
solution is to have them run in their own environment without access
to anything on my computer. Given that, the best interface for them is
probably a web-based UI that can deliver notifications when I need
them. The flow is pretty much the same as chat with channels--each
channel would be a separate conversation or task with an agent. I
never thought I'd advocate for the compiler and code to be on some
remote machine.

The big names already have offerings in this area, but they seem to be
in the early stages. Anthropic has a Claude Code research preview
where you can connect to your GitHub account and have it create PRs
form your prompt. Google has Jules which can do the same thing. Google
also released Antigravity which seems to have multiple modes where
you either get an editor like VS Code or you could manage remote
agents. I got Antigravity running in Guix with the help of Gemini
CLI. `xdg-open` wasn't working so I sort of had it hack a way I could
get the URL to paste into flatpak firefox so I could log in. It's
still sort of buggy though:

```sh
#!/usr/bin/env bash
# Run antigravity in a Guix FHS container (Wayland/Sway)

# Extract the dbus socket path from DBUS_SESSION_BUS_ADDRESS
DBUS_SOCKET=$(echo "$DBUS_SESSION_BUS_ADDRESS" | sed 's/.*path=\([^,]*\).*/\1/')

# Create wrapper directory
WRAPPER_DIR="$PWD/.xdg-wrappers"
mkdir -p "$WRAPPER_DIR"
LOG_FILE="$PWD/xdg-open.log"
cat > "$WRAPPER_DIR/xdg-open" << EOF
#!/bin/bash
echo "\$(date '+%Y-%m-%d %H:%M:%S') - xdg-open called with: \$@" >> "$LOG_FILE"
exit 0
EOF
chmod +x "$WRAPPER_DIR/xdg-open"

guix shell --container --emulate-fhs \
  --preserve='^WAYLAND_DISPLAY$' \
  --preserve='^XDG_RUNTIME_DIR$' \
  --preserve='^DBUS_SESSION_BUS_ADDRESS$' \
  --preserve='^HOME$' \
  --expose="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" \
  --expose="$DBUS_SOCKET" \
  --expose="$XDG_RUNTIME_DIR/dbus-1" \
  --expose="$HOME/.guix-profile/bin" \
  --expose="$HOME/.guix-home/profile/bin" \
  --expose=/run/current-system/profile/bin \
  --expose=/dev/dri \
  --expose=/sys/dev \
  --expose=/sys/devices \
  --share="$PWD"="$PWD" \
  --share="$HOME/.config" \
  --network \
  bash coreutils \
  gtk+ glib nss nss-certs \
  at-spi2-core \
  cups \
  eudev \
  alsa-lib \
  gcc-toolchain \
  dbus \
  xdg-utils \
  -- bash -c "
    export PATH='$PWD/.xdg-wrappers':\$PATH
    cd '$PWD' && ./antigravity \
      --enable-features=UseOzonePlatform \
      --ozone-platform=wayland \
      --disable-gpu-sandbox \
      --disable-dev-shm-usage \
      \"\$@\"
  "

```
