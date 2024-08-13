#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

echo "Checking if /usr/bin/fd exists"
if [ -e /usr/bin/fd ]; then
	echo "fd binary already exists, no need to redownload it"
else
	rpm-ostree install fd-find
fi

get_yaml_array ADD_FILES '.add[]' "$1"

mkdir -p /usr/share/bluebuild/image-pinned-etcs/

if [[ ${#ADD_FILES[@]} -gt 0 ]]; then
	cd "$CONFIG_DIRECTORY/image-pinned-etcs"

	echo "Adding files to image-pinned-etcs"
	for entry in "${ADD_FILES[@]}"; do
		if [ ! -e "$CONFIG_DIRECTORY/image-pinned-etcs/$entry" ]; then
			echo "Entry $entry Does Not Exist in $CONFIG_DIRECTORY/image-pinned-etcs"
			exit 1
		fi

		echo "Copying $entry to /usr/share/bluebuild/image-pinned-etcs"
		cp -rf $CONFIG_DIRECTORY/image-pinned-etcs/$entry/* /usr/share/bluebuild/image-pinned-etcs/
		DIRS_TO_CREATE=($(fd --type directory --base-directory $CONFIG_DIRECTORY/image-pinned-etcs/$entry | xargs))
		FILES_TO_LINK=($(fd --type file --base-directory $CONFIG_DIRECTORY/image-pinned-etcs/$entry | xargs))

		for dir in "${DIRS_TO_CREATE[@]}"; do
			mkdir -p /usr/etc/$dir
		done

		for file in "${FILES_TO_LINK[@]}"; do
			if [ -e /usr/etc/$file ]; then
				rm /usr/etc/$file
			fi
			echo "Creating symlink at /usr/etc/$file that points to /usr/share/bluebuild/image-pinned-etcs/$file"
			ln -s /usr/share/bluebuild/image-pinned-etcs/$file /usr/etc/$file
		done
	done
fi
