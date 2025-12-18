---
date: 2025-12-18
tags:
- guix
- rust
title: "Unstable Rust in Guix Home"
---

I recently wanted to do a better job sandboxing my AI agent work, so I
created an unprivileged user on my machine with their own home
and source directories to code. There are better ways to sandbox AI
agents, and this is not a guide on that. To illustrate Guix home
configuration, I wanted to show custom packages because I believe
setting up and maintaining a channel is too much overhead. A couple
minutes of vibe coding revealed this `guix-home-config.scm`:


```scheme
;; This is a sample Guix Home configuration which can help setup your
;; home directory in the same declarative manner as Guix System.
;; For more information, see the Home Configuration section of the manual.
(define-module (guix-home-config)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu services)
  #:use-module (gnu packages)
  #:use-module (gnu system shadow)
  ;; Modules required for the custom Rust package
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages compression)
  #:use-module (guix gexp))

;; npm config set prefix ~/npm
;; npm install -g @anthropic-ai/claude-code
;; npm install -g @google/gemini-cli
;; npm install -g @github/copilot

;; --- Custom Rust Nightly Definition ---

(define rust-nightly-date "2025-10-03")

(define rust-src-nightly
  (origin
    (method url-fetch)
    (uri (string-append
          "https://static.rust-lang.org/dist/"
          rust-nightly-date
          "/rust-src-nightly.tar.xz"))
    (sha256
     (base32
      "11bzbil0crzq6p9jq3a78bz0g3hhdcwin8gxk2d6f6kzs63mgd41"))))

(define-public rust-nightly
  (package
    (name "rust-nightly")
    (version rust-nightly-date)
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://static.rust-lang.org/dist/"
             rust-nightly-date
             "/rust-nightly-x86_64-unknown-linux-gnu.tar.gz"))
       (sha256
        (base32
         "1ww9mpcp314q4nk7ykp2blkvw66zmiy4c01v02fg0asrdh17vspr"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:validate-runpath? #f
      #:strip-binaries? #f
      #:modules '((guix build gnu-build-system)
                  (guix build utils))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'build)
          (add-after 'unpack 'unpack-rust-src
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((rust-src (assoc-ref inputs "rust-src")))
                (invoke "tar" "-xf" rust-src))))
          (replace 'install
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (invoke "./install.sh"
                        (string-append "--prefix=" out)
                        "--components=rustc,cargo,rust-std-x86_64-unknown-linux-gnu,rustfmt-preview,clippy-preview")
                (chdir "rust-src-nightly")
                (invoke "./install.sh"
                        (string-append "--prefix=" out)
                        "--components=rust-src")
                (chdir ".."))))
          (add-after 'install 'patch-rust-src-checksums
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (library-lock (string-append out "/lib/rustlib/src/rust/library/Cargo.lock"))
                     (dummy-hash "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"))
                (when (file-exists? library-lock)
                  (substitute* library-lock
                    (("(checksum = )\"[a-f0-9]+\"" all prefix)
                     (string-append prefix "\"" dummy-hash "\"")))))))
          (add-after 'install 'patch-binaries
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (gcc-toolchain (assoc-ref inputs "gcc-toolchain"))
                     (zlib (assoc-ref inputs "zlib"))
                     (rpath (string-append out "/lib:"
                                          gcc-toolchain "/lib:"
                                          zlib "/lib")))
                (for-each
                 (lambda (file)
                   (when (and (file-exists? file)
                              (not (file-is-directory? file))
                              (elf-file? file))
                     (invoke "patchelf" "--set-rpath" rpath file)
                     (unless (string-contains file ".so")
                       (invoke "patchelf" "--set-interpreter"
                               (string-append gcc-toolchain
                                              "/lib/ld-linux-x86-64.so.2")
                               file))))
                 (find-files out ".*")))))
          (add-after 'patch-binaries 'wrap-programs
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (gcc-toolchain (assoc-ref inputs "gcc-toolchain"))
                     (lib-path (string-append gcc-toolchain "/lib"))
                     (gcc-bin (string-append gcc-toolchain "/bin/gcc")))
                (wrap-program (string-append out "/bin/rustc")
                  `("LIBRARY_PATH" ":" suffix (,lib-path)))
                (wrap-program (string-append out "/bin/cargo")
                  `("LIBRARY_PATH" ":" suffix (,lib-path))
                  `("RUSTFLAGS" " " suffix (,(string-append "-C linker=" gcc-bin " -C link-arg=-Wl,-rpath," lib-path))))))))))
    (native-inputs
     `(("patchelf" ,patchelf)
       ("rust-src" ,rust-src-nightly)))
    (inputs
     (list gcc-toolchain zlib))
    (home-page "https://www.rust-lang.org")
    (synopsis "Rust nightly toolchain")
    (description "Rust nightly binary")
    (license (list license:asl2.0 license:expat))))

;; --- Home Environment ---

(define home-config
  (home-environment
    (packages 
	  (cons rust-nightly
        (specifications->packages 
		  (list "foot" "texinfo" "procps" "bubblewrap" "node" "emacs" "git:credential-netrc"
                 "git:send-email" "pinentry" "git" "bind:utils" "gcc-toolchain" "python"
                 "rsync" "bzip2" "cpio" "lsof" "xxd" "less" "patchelf" "unzip" "strace" "zstd"
                 "make" "which" "wget" "curl" "tar" "gzip" "file"))))
    (services
      (append
        (list
          ;; Uncomment the shell you wish to use for your user:
          (service home-bash-service-type
                   (home-bash-configuration
                    (aliases
                     '(("copilot" . "env COPILOT_ALLOW_ALL=1 node $HOME/npm/bin/copilot")
                       ("gemini" . "node $HOME/npm/bin/gemini")
                       ("claude" . "node $HOME/npm/bin/claude --allow-dangerously-skip-permissions")))))
          ;(service home-fish-service-type)
          ;(service home-zsh-service-type)

          (service home-files-service-type
           `((".guile" ,%default-dotguile)
             (".Xdefaults" ,%default-xdefaults)))

          (service home-xdg-configuration-files-service-type
           `(("gdb/gdbinit" ,%default-gdbinit)
             ("nano/nanorc" ,%default-nanorc))))

        %base-home-services))))

home-config

```

Unfortunately, packaging rust unstable like this is a little gross,
but it was able to build a simple hello world program. Anyways, it's
for illustrative purposes.
