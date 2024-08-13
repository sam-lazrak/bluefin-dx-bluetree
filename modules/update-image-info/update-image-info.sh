#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

nu $MODULE_DIRECTORY/update-image-info/update-image-info.nu $IMAGE_NAME $BASE_IMAGE