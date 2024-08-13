export project_root := `git rev-parse --show-toplevel`

_default:
    @just --list --list-heading $'Available commands:\n' --list-prefix $' - '

# Check Just Syntax
just-check:
    #!/usr/bin/bash
    find "${project_root}" -type f -name "*.just" | while read -r file; do
    	echo "Checking syntax: $file"
    	just --unstable --fmt --check -f $file 
    done
    echo "Checking syntax: ${project_root}/justfile"
    just --unstable --fmt --check -f ${project_root}/justfile

# Fix Just Syntax
just-fix:
    #!/usr/bin/bash
    find "${project_root}" -type f -name "*.just" | while read -r file; do
    	echo "Checking syntax: $file"
    	just --unstable --fmt -f $file
    done
    echo "Checking syntax: ${project_root}/justfile"
    just --unstable --fmt -f ${project_root}/justfile || { exit 1; }

# Create ISO from ghcr image
build-iso-ghcr image="" tag="" file_output="__prompt":
    #!/usr/bin/bash
    if [ "{{ image }}" = "" ]; then
      images=$(fd --base-directory ${project_root}/recipes/images/ -d 2 | grep .yml | sed 's/\.yml$//' | awk -F '/' '{print $2}' | awk -F '--' '{print $1}' | uniq | xargs)
      chosen_image=$(ugum choose $(echo $images) --header "Choose image name")
    else
      chosen_image={{ image }}
    fi

    if [[ "{{ tag }}" = "" ]]; then

      if [[ "$chosen_image" =~ "bluefin" ]] || [[ "$chosen_image" =~ "aurora" ]]; then
        want_to_custom_tag=$(ugum choose "gts" "stable" "latest" "other" --header "Choose image tag:")
      fi

      if [[ "$want_to_custom_tag" = "other" ]] || [[ "$want_to_custom_tag" = "" ]]; then
        chosen_tag=$(ugum input)
      else
        chosen_tag=$want_to_custom_tag
      fi
    else
      chosen_tag={{ tag }}
    fi

    if [ "{{ file_output }}" = "__prompt" ]; then
      want_to_custom_file_output=$(ugum choose "auto-generated" "custom" --header "Choose file output:")
      if [ "$want_to_custom_file_output" = "custom" ]; then
        echo " ## WARNING: custom file outputs are untested and may not work correctly ## "
        chosen_file_output=$(ugum input)
      else
        chosen_file_output="__auto"
      fi
    else
      chosen_file_output={{ file_output }}
    fi

    {{ project_root }}/scripts/build-iso-ghcr.sh $chosen_image $chosen_tag $chosen_file_output
