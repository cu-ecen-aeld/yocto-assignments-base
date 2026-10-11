#!/bin/bash
# Script to start qemu

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INIT_ENV_SCRIPT="${SCRIPT_DIR}/bitbake-builds/yocto-assignments-wrynose/build/init-build-env"
source ${INIT_ENV_SCRIPT}
# Use slirp so we don'tneed to run as root, and pass through the ports we need from the host side for testing
export QB_SLIRP_OPT="-netdev user,id=net0,hostfwd=tcp::10022-:22,hostfwd=tcp::9000-:9000"
# Specify the ext4 version of the image so we don't need to use snapshot mode
runqemu slirp nographic core-image-aesd ext4
