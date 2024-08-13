#!/usr/bin/env bash

set -euo pipefail

FILE_DOWNLOAD="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn/hosts"
OUTPUT_FILE="/usr/share/bluebuild/image-pinned-etcs/hosts"
SYMLINK_FILE="/usr/etc/hosts.d/stevenblack-hosts.conf"

mkdir -p $(dirname $SYMLINK_FILE)

wget $FILE_DOWNLOAD -O $OUTPUT_FILE
echo "Creating symlink at $SYMLINK_FILE that points to $OUTPUT_FILE"
ln -s $OUTPUT_FILE $SYMLINK_FILE
