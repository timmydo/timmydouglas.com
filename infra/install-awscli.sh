#!/usr/bin/env bash
set -euo pipefail

# Install AWS CLI v2 to ~/.local/bin and patch ELF binaries for Guix

INSTALL_DIR="$HOME/.local/aws-cli"
BIN_DIR="$HOME/.local/bin"
AWS_DIST="$INSTALL_DIR/v2/dist"

echo "--- Downloading AWS CLI v2 ---"
cd /tmp
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -qo awscliv2.zip

echo "--- Installing to $INSTALL_DIR ---"
./aws/install --install-dir "$INSTALL_DIR" --bin-dir "$BIN_DIR" --update

echo "--- Patching ELF binaries for Guix ---"
GLIBC_LIB=$(dirname "$(realpath "$(which ld.so 2>/dev/null || echo /gnu/store/*/lib/ld-linux-x86-64.so.2)" 2>/dev/null)" 2>/dev/null) || true

# Find glibc and zlib from the guix profile
if [ -z "$GLIBC_LIB" ] || [ ! -d "$GLIBC_LIB" ]; then
    GLIBC_LIB=$(dirname "$(realpath /gnu/store/*-glibc-*/lib/ld-linux-x86-64.so.2 2>/dev/null | tail -1)")
fi

ZLIB_LIB=$(dirname "$(realpath /gnu/store/*-zlib-*/lib/libz.so.1 2>/dev/null | tail -1)")

if [ -z "$GLIBC_LIB" ] || [ -z "$ZLIB_LIB" ]; then
    echo "Error: Could not find glibc or zlib in /gnu/store"
    echo "Try: guix install glibc zlib"
    exit 1
fi

INTERP="${GLIBC_LIB}/ld-linux-x86-64.so.2"
RPATH="${GLIBC_LIB}:${ZLIB_LIB}"

patchelf --set-interpreter "$INTERP" --set-rpath "$RPATH" "$AWS_DIST/aws"

echo "--- Verifying ---"
"$BIN_DIR/aws" --version

echo ""
echo "AWS CLI installed to $BIN_DIR/aws"
echo "Run '$BIN_DIR/aws configure' to set up credentials."
