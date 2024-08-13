let image_name = $"(cat /usr/share/ublue-os/image-info.json | from json | get image-name)"

let fetch_logo = "/usr/share/ublue-os/fastfetch/logos/ublue-fastfetch-logo"

if ($image_name =~ "bluefin") {
    let fetch_logo = $"(/usr/bin/find /usr/share/ublue-os/bluefin-logos/symbols/* | /usr/bin/shuf -n 1)"
} else if ($image_name =~ "aurora") {
    let fetch_logo = "/usr/share/ublue-os/fastfetch-logos/aurora-fastfetch-logo"
}

alias smallfetch = /usr/bin/fastfetch -c /usr/share/ublue-os/fastfetch/configs/small.jsonc --logo ($fetch_logo)
alias bigfetch = /usr/bin/fastfetch -c /usr/share/ublue-os/fastfetch/configs/large.jsonc --logo ($fetch_logo)

alias fastfetch = bigfetch
alias neofetch = fastfetch