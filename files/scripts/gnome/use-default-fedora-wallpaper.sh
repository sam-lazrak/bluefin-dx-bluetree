#!/usr/bin/env bash

set -euo pipefail

fedora_version=$(cat /usr/share/ublue-os/image-info.json | jq -r '.["fedora-version"]')
wall_dir="/usr/share/backgrounds/f${fedora_version}/default"
wall_light="$wall_dir/f${fedora_version}-01-day.png"
wall_dark="$wall_dir/f${fedora_version}-01-night.png"

config_file="/usr/etc/dconf/db/local.d/50-myublue"

echo "[org/gnome/desktop/background]" >>$config_file
echo "picture-uri='file://$wall_light'" >>$config_file
echo "picture-uri-dark='file://$wall_dark'" >>$config_file
echo "picture-options='zoom'" >>$config_file
echo "primary-color='000000'" >>$config_file
echo "secondary-color='FFFFFF'" >>$config_file
