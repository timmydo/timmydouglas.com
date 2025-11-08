---
date: 2025-11-08
tags:
- cargo
- rust
- zed
title: "Running a Recent Rust to Compile Zed on Guix"
---

While I'm still running GNU Guix as the OS of choice for my personal
computer, my patience is wearing thin when it comes to it's
all-or-nothing approach when it comes to running software. For those
who don't use Guix or Nix, the basic idea is that the read-only root
filesystem only has `/bin/sh ->
/gnu/store/p5dap5q3wfdy0h3m31q5hbj3gpbkmrxv-bash-5.2.37/bin/sh` and
`/usr/bin/env ->
/gnu/store/f2rcir6yz0n74jaa6d0fm82f8flmwjnk-coreutils-9.1/bin/env`. There
are no other files in `/bin` or `/usr` or `/lib`. All the programs installed are
in `/gnu/store` and
`PATH=/home/timmy/.guix-home/profile/bin:/home/timmy/.guix-home/profile/sbin:/run/privileged/bin:/home/timmy/.config/guix/current/bin`. I
use Guix home to configure all the software I want installed, which is
a nice touch, because I can check that file into git and take it
anywhere. At the end of the day though, not following Linux FHS
(filesystem hierarchy standard) causes a lot of pain, probably because
most software developers aren't aware and don't put the proper
customization points into their code.

If you want something like the latest version of rust, and that isn't
packaged for Guix, that's where the pain starts. If
something isn't packaged, then you probably need to package it
yourself or you're not going to run it. There is the alternative of
running podman, which saved me when it came to building
[Redox](https://www.redox-os.org/) locally, but let's ignore the
Dockerfile scenario.

While every piece of complicated software has its own particular
complications with build, the rust ecosystem seems to pretty heavily
rely on `rustup` to install the build toolchain for building rust
applications. From my little experience with it, it appears the rust
culture accepts the binary distribution when it comes to rust
binaries, and that does not mesh well with Guix.

So my story begins this Saturday morning when I have a couple of hours
for myself and I want to try out the Zed editor on Guix. Rust version
1.90 is not packaged, and it appears that is required. Claude code is
able to hack this together while I'm cleaning the house, which was
enough to run Zed with `guix shell -m manifest.scm -f rust-1.90.scm --
./guix-cargo run`:

`manifest.scm`:
```scheme
;; Development environment for building Zed
(specifications->manifest
 '("gcc-toolchain"
   "pkg-config"
   "clang"
   "mold"
   "cmake"
   "protobuf"
   "alsa-lib"
   "fontconfig"
   "wayland"
   "wayland-protocols"
   "libxkbcommon"
   "libxcb"
   "xcb-util-wm"
   "vulkan-loader"
   "vulkan-headers"
   "mesa"
   "libglvnd"
   "sqlite"
   "zstd"
   "openssl"
   "curl"))
```

`rust-1.90.scm`:
```scheme
(use-modules (guix packages)
             (guix download)
             (guix build-system gnu)
             (guix build utils)
             (guix search-paths)
             ((guix licenses) #:prefix license:)
             (gnu packages base)
             (gnu packages gcc)
             (gnu packages commencement)
             (gnu packages compression)
             (gnu packages elf)
             (gnu packages bootstrap)
             (gnu packages linux)
             (gnu packages pkg-config)
             (gnu packages tls)
             (gnu packages curl)
             (ice-9 match)
             (ice-9 ftw))

(define rust-version "1.90.0")

(define-public rust-1.90
  (package
    (name "rust")
    (version rust-version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://static.rust-lang.org/dist/"
             "rust-" version "-x86_64-unknown-linux-gnu.tar.gz"))
       (sha256
        (base32
         "1186b7xd4hp4dr61am6i9hb0h4vksm958p06mqpgw0ldqvhvllz4"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f  ; No test suite in binary distribution
       #:validate-runpath? #f  ; We'll handle this ourselves
       #:strip-binaries? #f    ; Don't strip Rust binaries
       #:modules ((guix build gnu-build-system)
                  (guix build utils))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (invoke "./install.sh"
                       (string-append "--prefix=" out)
                       "--components=rustc,cargo,rust-std-x86_64-unknown-linux-gnu,rustfmt-preview,clippy-preview"))))
         (add-after 'install 'patch-binaries
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (gcc-toolchain (assoc-ref inputs "gcc-toolchain"))
                    (zlib (assoc-ref inputs "zlib"))
                    (openssl (assoc-ref inputs "openssl"))
                    (curl (assoc-ref inputs "curl"))
                    (rpath (string-append out "/lib:"
                                          gcc-toolchain "/lib:"
                                          zlib "/lib:"
                                          openssl "/lib:"
                                          curl "/lib")))
               (for-each
                (lambda (file)
                  (when (and (file-exists? file)
                             (not (file-is-directory? file))
                             (elf-file? file))
                    (system* "patchelf" "--set-rpath" rpath file)
                    (unless (string-contains file ".so")
                      (system* "patchelf" "--set-interpreter"
                               (string-append gcc-toolchain
                                              "/lib/ld-linux-x86-64.so.2")
                               file))))
                (find-files out ".*"))
               #t)))
         (add-after 'patch-binaries 'wrap-rustc
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (gcc-toolchain (assoc-ref inputs "gcc-toolchain")))
               ;; Wrap rustc and cargo so they can find gcc libraries
               (wrap-program (string-append out "/bin/rustc")
                 `("LIBRARY_PATH" ":" suffix (,(string-append gcc-toolchain "/lib"))))
               (wrap-program (string-append out "/bin/cargo")
                 `("LIBRARY_PATH" ":" suffix (,(string-append gcc-toolchain "/lib"))))
               #t))))))
    (native-inputs
     (list tar gzip patchelf))
    (inputs
     (list gcc-toolchain zlib openssl curl))
    (native-search-paths
     (list (search-path-specification
            (variable "C_INCLUDE_PATH")
            (files '("include")))
           (search-path-specification
            (variable "CPLUS_INCLUDE_PATH")
            (files '("include/c++" "include")))
           (search-path-specification
            (variable "LIBRARY_PATH")
            (files '("lib" "lib64")))))
    (home-page "https://www.rust-lang.org")
    (synopsis "Rust programming language version 1.90")
    (description
     "Rust is a systems programming language that provides memory safety,
concurrency safety, and practical tools for writing reliable software.
This package provides Rust 1.90 as required by Zed.")
    (license (list license:asl2.0 license:expat))))

rust-1.90

```

And `guix-cargo`:
```sh
#!/bin/sh
# Wrapper for cargo that sets RUSTFLAGS to embed LIBRARY_PATH as RPATH
# This ensures compiled binaries can find their dependencies

# Use LIBRARY_PATH as RPATH
if [ -n "$LIBRARY_PATH" ]; then
    export RUSTFLAGS="${RUSTFLAGS:+$RUSTFLAGS }-C link-arg=-Wl,-rpath,$LIBRARY_PATH"
fi

exec cargo "$@"
```

Unfortunately, the binary nature of this doesn't look like something I
could contribute back to Guix, but maybe it will help someone else on
the internet, or a future AI bot who is learning what's needed to hack
together something similar.
