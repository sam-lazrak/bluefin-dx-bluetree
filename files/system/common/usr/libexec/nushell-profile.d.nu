#!/usr/bin/env nu

let profile_file = "/etc/nushell/profile"
let profile_dir = "/etc/nushell/profile.d"

echo "## Generated by nushell-profile.d ##\n" | save -f $profile_file
echo "## All changes in this file will be ignored ##\n" | save -a $profile_file

let files = (ls -a $profile_dir | get name)

for file in $files {
  echo $"source ($file)\n" | save -a $profile_file
}

chmod ugo=r $profile_file