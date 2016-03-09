#!/bin/bash

if [ -z "$BASH" ]; then printf "\nWRONG SHELL: '%s' SCRIPT needs 'bash'\n\n" "$(ps -p $$ -ocomm=)"; exit 1; fi
THIS_SCRIPT_PATH="$(readlink -f "$(type -P $0 || echo $0)")"
THIS_SCRIPT_DIR="$(dirname "$THIS_SCRIPT_PATH")"
source $THIS_SCRIPT_DIR/../p_linux_common_func.sh
trap "interrupted" SIGHUP SIGINT SIGQUIT SIGTERM
msg_format
check_have_gettext  $THIS_SCRIPT_PATH


color_header $BOLD_MSG "$(gettext "Running: automated 'Setting Common Variables'...")"


#************************************************************************************************************************
# COMMON VARIABLESS
#************************************************************************************************************************

msg "$(gettext "Exporting The 'LFS' Configuration Variable")"
export LFS='/mnt/lfs'

ARCH="$(uname -m)"

RAMDISK_MOUNTPOINT='pkgmk'
RAM_TARGET_LINK='/pkgmk'

SWAP_FILE='/lfs.swap'

LFS_USER_HOME_PATH='/home/lfs'

LFS_USER='lfs'
LFS_USER_PASSWORD='lfs'
LFS_GROUP='lfs'
LFS_USER_BASH_PROFILE="$LFS_USER_HOME_PATH/.bash_profile"
LFS_USER_BASHRC="$LFS_USER_HOME_PATH/.bashrc"
LFS_USER_LOGS_DIR="$LFS_USER_HOME_PATH/logs"

SOURCES_LINK='/sources'
TOOLS_LINK='/tools'


#************************************************************************************************************************
# End of file
#************************************************************************************************************************
