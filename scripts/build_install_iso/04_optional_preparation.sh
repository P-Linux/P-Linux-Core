#!/bin/bash

#************************************************************************************************************************
# HELPER FUNCTIONS
#************************************************************************************************************************

mount_a_ram_disk() {

    msg "$(gettext "Mounting A RAM Disk...")"

    msg_i "$(gettext "Mounting RAM_TARGET_LINK: '%s' as type: tmpfs")" "$RAM_TARGET_LINK"
    mount -t tmpfs -o defaults,noatime,size=80%  $RAMDISK_MOUNTPOINT $RAM_TARGET_LINK

    color_mesg $GREEN_MSG "$(gettext "       Use command 'df -h' from an other terminal to check RAMDISK Usage: '%s'")" \
        "$RAMDISK_MOUNTPOINT"
    echo
}

create_a_swap_file() {

    if [[ -n "$(swapon -s $SWAP_FILE)" ]]; then
        # unmount the SWAP-FILE in case one re-runs the script
        swapoff $SWAP_FILE
        rm -rf $SWAP_FILE
    fi

    msg "$(gettext "Creating A SWAP File: %s")" "$SWAP_FILE"
    fallocate -l 6G $SWAP_FILE

    msg_i "$(gettext "Formating The SWAP-Filee")"
    mkswap $SWAP_FILE &> /dev/null

    msg_i "$(gettext "'chmod' The SWAP-File")"
    chmod 600 $SWAP_FILE

    msg_i "$(gettext "Enable The SWAP-File")"
    swapon $SWAP_FILE

    color_mesg $GREEN_MSG "$(gettext "       Use command 'free -h' from an other terminal to check SWAP Usage")"
        
    echo
}


#************************************************************************************************************************
#   MAIN CHECKING SOME LIBRARY CONSISTENCY
#************************************************************************************************************************

if [ -z "$BASH" ]; then printf "\nWRONG SHELL: '%s' SCRIPT needs 'bash'\n\n" "$(ps -p $$ -ocomm=)"; exit 1; fi
THIS_SCRIPT_PATH="$(readlink -f "$(type -P $0 || echo $0)")"
THIS_SCRIPT_DIR="$(dirname "$THIS_SCRIPT_PATH")"
source $THIS_SCRIPT_DIR/../p_linux_common_func.sh
trap "interrupted" SIGHUP SIGINT SIGQUIT SIGTERM
msg_format
check_have_gettext  $THIS_SCRIPT_PATH

color_header $BOLD_MSG "$(gettext "Running: automated 'Optional Preparation'...")"

mount_a_ram_disk
create_a_swap_file


#************************************************************************************************************************
# End of file
#************************************************************************************************************************
