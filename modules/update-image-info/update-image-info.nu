#!/usr/bin/env nu

def main [
    image_name: string
    base_image: string
] {
    let file_path = "/usr/share/ublue-os/image-info.json"
    let image_vendor = "noahdotpy"
    
    let config = open $file_path

    let new_configs = {
        image-name: $image_name
        image-vendor: $image_vendor
        image-ref: $"ostree-image-signed:docker://ghcr.io/($image_vendor)/($image_name)"
        bluebuild-base-image: $base_image
    }

    let new_config = $config | merge $new_configs
    echo ($new_config | to json)
    echo $new_config | to json | save -f $file_path
}