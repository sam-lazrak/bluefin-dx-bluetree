#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

get_yaml_array FILES '.files[]' "$1"

shopt -s dotglob

if [[ ${#FILES[@]} -gt 0 ]]; then
	echo "Removing files from image"
	for TARGET in "${FILES[@]}"; do
		TARGET=$(echo $TARGET | xargs)
		if ! [ -e "$TARGET" ]; then
			echo "File or Directory $TARGET Already Does Not Exist"
			continue
		fi

		rm -rf $TARGET
		echo "Removing $TARGET"
	done
fi

shopt -u dotglob
