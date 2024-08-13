#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

echo "DONT USE THIS MODULE ANYMORE"
exit 1










echo "Checking if /usr/bin/chezmoi exists"
if [ -e /usr/bin/chezmoi ]; then
	echo "chezmoi binary already exists, no need to redownload it"
else
	echo "Checking if curl is installed and executable at /usr/bin/curl"
	if [ -x /usr/bin/curl ]; then
		echo "Downloading chezmoi binary from the latest Github release"
		/usr/bin/curl -Ls https://github.com/twpayne/chezmoi/releases/latest/download/chezmoi-linux-amd64 -o /usr/bin/chezmoi
		echo "Ensuring chezmoi is executable"
		/usr/bin/chmod 755 /usr/bin/chezmoi
	else
		echo "ERROR: curl could not be found in /usr/bin/."
		echo "Please make sure curl is installed on the system you are building your image."
		exit 1
	fi
fi

cp -r {"$MODULE_DIRECTORY"/homefiles,/usr/lib/systemd/user}/bluebuild-homefiles-apply.service
cp -r {"$MODULE_DIRECTORY"/homefiles,/usr/lib/systemd/user}/bluebuild-homefiles-apply.path
cp -r {"$MODULE_DIRECTORY"/homefiles,/usr/bin}/bluebuild-homefiles-apply

get_yaml_array ADD_HOMEFILES '.add[]' "$1"

DISABLE_SERVICE=$(echo "$1" | yq -I=0 ".disable-service") # (boolean)
if [[ -z $DISABLE_SERVICE || $DISABLE_SERVICE == "null" ]]; then
	DISABLE_SERVICE=false
fi

if [[ $DISABLE_SERVICE == "false" ]]; then
	systemctl --global enable bluebuild-homefiles-apply.path
elif [[ $DISABLE_SERVICE == "true" ]]; then
	systemctl --global disable bluebuild-homefiles-apply.path	
fi

if [[ ${#ADD_HOMEFILES[@]} -gt 0 ]]; then
	echo "Adding home files to image"
	mkdir -p /usr/share/bluebuild/homefiles/
	for entry in "${ADD_HOMEFILES[@]}"; do
		cp -r $CONFIG_DIRECTORY/homefiles/$entry /usr/share/bluebuild/homefiles/$entry

		chezmoi apply --destination /usr/etc/skel/ --source /usr/share/bluebuild/homefiles/$entry --force
	done
else
	echo "There are no homefiles directories added."
	exit 1
fi