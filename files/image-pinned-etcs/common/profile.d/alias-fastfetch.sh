#!/usr/bin/sh
IMAGE_NAME=$(cat /usr/share/ublue-os/image-info.json | jq -r '.["image-name"]')

if [[ "$IMAGE_NAME" =~ "bluefin" ]]; then
	FETCH_LOGO="$(/usr/bin/find /usr/share/ublue-os/bluefin-logos/symbols/* | /usr/bin/shuf -n 1)"
elif [[ "$IMAGE_NAME" =~ "aurora" ]]; then
	FETCH_LOGO="/usr/share/ublue-os/fastfetch-logos/aurora-fastfetch-logo"
else
	FETCH_LOGO="/usr/share/ublue-os/fastfetch-logos/ublue-fastfetch-logo"
fi

alias smallfetch="/usr/bin/fastfetch -c /usr/share/ublue-os/fastfetch/configs/small.jsonc --logo ${FETCH_LOGO}"
alias bigfetch="/usr/bin/fastfetch -c /usr/share/ublue-os/fastfetch/configs/large.jsonc --logo ${FETCH_LOGO}"

alias fastfetch="bigfetch"
