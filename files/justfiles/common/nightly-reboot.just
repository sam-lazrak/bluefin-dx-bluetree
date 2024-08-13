# vim: set ft=make :

# Turn automatic nightly reboots on or off (every night at 3AM)
toggle-nightly-reboots ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Disabled"
    if systemctl is-enabled nightly-reboot.timer | grep -q enabled; then
      CURRENT_STATE="Enabled"
    fi
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "Automatic nightly reboots are currently: ${bold}${CURRENT_STATE}${normal}"
      echo "Enable or Disable automatic nightly reboots?"
      OPTION=$(ugum choose Enable Disable)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust toggle-nightly-reboots <option>"
      echo "  <option>: Specify the quick option - 'enable' or 'disable'"
      echo "  Use 'enable' to Enable automatic nightly reboots."
      echo "  Use 'disable' to Disable automatic nightly reboots."
      exit 0
    fi
    if [ "${OPTION,,}" == "enable" ]; then
      sudo systemctl enable nightly-reboot.timer
    elif [ "${OPTION,,}" == "disable" ]; then
      sudo systemctl disable nightly-reboot.timer
    fi
