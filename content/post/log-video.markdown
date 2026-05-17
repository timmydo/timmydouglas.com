---
date: 2026-05-16
tags:
- nikon
- nlog
- linux
title: "Trying Log-Encoded Videography"
---

I recently started trying to shoot video on my Nikon Z8. Because I
shoot RAW for still photos, I thought I would try shooting N-Log
footage as an equivalent. I quickly discovered the world of color
grading, and it's quite a step up in complexity from processing RAW
photos.

I started by trying to get a DaVinci Resolve flatpak to work. It's a
little tricky with my Sway/Guix setup because I'm not running XWayland
and I read DaVinci Resolve is a little finicky about the linux distro
you use. I was able to get it to start up with Claude's help, but it
was crashing when I imported video in one of the libraries for
processing video. Long story short, I gave up on that and tried
kdenlive.

Kdenlive was stable and worked well out of the box for me. However, I
struggled getting the color I wanted right even though I was able to
download and apply the Nikon LUT. I think Kdenlive might have
been more focused on color grading normal videos rather than ones on
a log scale. To get the contrast I wanted I felt like I had to use a
custom curve, and replicating that on every cut I had started to add a
lot of time to something I wasn't really interested in doing. Maybe it
would get easier with time but I guess it sort of took the fun out of
it for me. Along the same lines, sometimes processing photos gets
tiring, but not to the point where I shoot with JPEG. I think if
cameras got to the point where you could have a 10 or 12-bit
pre-processed JPEG XL photo coming out of the camera, I might still
shoot RAW.

Ultimately, in the environment I was shooting video in, I don't think
I need another N levels of dynamic range, and I don't want to spend an
hour on color if I'm making essentially home videos. It's already
noticeably nicer than cell phone footage or any home video setup I had
when I was a kid. It was great to have a video off the camera that was
ready to upload, of course after I got my AI agent to put together a
ffmpeg command line to make it smaller/internet-ready.


