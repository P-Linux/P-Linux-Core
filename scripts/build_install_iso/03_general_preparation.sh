#!/bin/bash

#************************************************************************************************************************
# HELPER FUNCTIONS
#************************************************************************************************************************

clean_previous_setup() {
    local ret=0

    msg "$(gettext "Cleaning Previous Setup...")"

    msg_i "$(gettext "Removing LFS_USER         : '%s' And Home-Directory")" "$LFS_USER"
    if id -u $LFS_USER &> /dev/null; then
        userdel --force --remove $LFS_USER &> /dev/null || \
            abort "$(gettext "Couldn't delete LFS_USER: '%s'")" "$LFS_USER"
    fi

    msg_i "$(gettext "Removing LFS_GROUP        : '%s'")" "$LFS_GROUP"
    if id -G $LFS_GROUP &> /dev/null; then
        groupdel $LFS_GROUP || abort "$(gettext "Couldn't delete LFS_GROUP: '%s'")" "$LFS_GROUP"
    fi

    msg_i "$(gettext "Removing LFS-TARGET-DIR   : '%s'")" "$LFS"
    # unmount first any mountpoint 'pkgmk': otherwise one gets: rm: cannot remove: Device or resource busy
    if mountpoint -q $RAM_TARGET_LINK; then
        umount $RAMDISK_MOUNTPOINT || abort "$(gettext "Couldn't umount RAMDISK_MOUNTPOINT: '%s'")" "$RAMDISK_MOUNTPOINT"
    fi
    if [[ -e "$LFS" ]]; then
        rm -rf $LFS || abort "$(gettext "Couldn't remove LFS_TARGET_DIR: '%s'")" "$LFS"
    fi

    msg_i "$(gettext "Removing Related Links    : '%s', '%s', '%s'")" "$TOOLS_LINK" "$SOURCES_LINK" "$RAM_TARGET_LINK"
    if [[ -e "$TOOLS_LINK" ]]; then
        rm -rf $TOOLS_LINK || abort "$(gettext "Couldn't remove TOOLS_LINK: '%s'")" "$TOOLS_LINK"
    fi
    if [[ -e "$SOURCES_LINK" ]]; then
        rm -rf $SOURCES_LINK || abort "$(gettext "Couldn't remove SOURCES_LINK: '%s'")" "$SOURCES_LINK"
    fi
    if [[ -e "$RAM_TARGET_LINK" ]]; then
        rm -rf $RAM_TARGET_LINK || abort "$(gettext "Couldn't remove RAM_TARGET_LINK: '%s'")" "$RAM_TARGET_LINK"
    fi

    msg_i "$(gettext "Removing Related SWAP_FILE: '%s'")" "$SWAP_FILE"
    if [[ -n "$(swapon -s $SWAP_FILE)" ]]; then
        swapoff $SWAP_FILE  || abort "$(gettext "Couldn't swapoff SWAP_FILE: '%s'")" "$SWAP_FILE"
        rm -rf $SWAP_FILE   || abort "$(gettext "Couldn't rm SWAP_FILE: '%s'")" "$SWAP_FILE"
    fi

    echo
}

create_a_new_setup() {

    msg "$(gettext "Creating A New Setup...")"

    msg_i "$(gettext "Creating Folders         : '%s', '%s', '%s'")" "$LFS/tools" "$LFS/sources" "$LFS/pkgmk"
    mkdir -p $LFS/{sources,tools,pkgmk}    || abort "$(gettext "Couldn't create '%s' subfolders.")" "$LFS"
    
    msg_i "$(gettext "Creating Links           : '%s', '%s', '%s'")" "$TOOLS_LINK" "$SOURCES_LINK" "$RAM_TARGET_LINK"
    ln -sf $LFS/tools /                    || abort "$(gettext "Couldn't create Link: %s/tools")" "$LFS"
    ln -sf $LFS/sources /                  || abort "$(gettext "Couldn't create Link: %s/sources")" "$LFS"
    ln -sf $LFS/pkgmk /                    || abort "$(gettext "Couldn't create Link: %s/pkgmk")" "$LFS"

    msg_i "$(gettext "Creating LFS_GROUP       : '%s'")" "$LFS_GROUP"
    groupadd $LFS_GROUP || abort "$(gettext "Couldn't create LFS_GROUP: '%s'")" "$LFS_GROUP"

    msg_i "$(gettext "Creating LFS_USER        : '%s' ")" "$LFS_USER"
    useradd -s /bin/bash -g $LFS_GROUP -m -k /dev/null $LFS_USER || \
        abort "$(gettext "Couldn't create LFS_USER: '%s' And Home-Directory")" "$LFS_USER"
    plain_i "$(gettext "Setting LFS_USER_PASSWORD: new password: '%s'")" "$LFS_USER_PASSWORD"
    echo "$LFS_USER:$LFS_USER_PASSWORD" | chpasswd -m || \
        abort "$(gettext "Couldn't set LFS_USER_PASSWORD to: '%s'")" "$LFS_USER_PASSWORD"

    msg_i "$(gettext "Setting Owner Of '%s' and sub-folders to: '%s'")"  "$LFS" "$LFS_USER"
    chown -R $LFS_USER $LFS || abort "$(gettext "Couldn't set Owner of: '%s' to: '%s'")" "$LFS" "$LFS_USER" 

    msg_i "$(gettext "Setting Mode to <writable and sticky> Folder: '%s/sources'")" "$LFS"
    chmod a+wt $LFS/sources || abort "$(gettext "Couldn't set'directory writable and sticky' for: %s/sources")" "$LFS"

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

color_header $BOLD_MSG "$(gettext "Running: automated 'General Preparation'...")"

msg "$(gettext "Checking Supported Host Architecture...")"
[ "$ARCH" == "x86_64" ] || abort "$(gettext "Supported host architecture is x86_64. Found: %s")" "$ARCH"

clean_previous_setup
create_a_new_setup

# This continues the create_a_new_setup: we do it here because we us no indentation for `cat`

msg_i "$(gettext "Creating For LFS_USER: '%s' Files & Directories...")" "$LFS_USER"
plain_i "$(gettext "Creating LFS_USER_BASH_PROFILE: '%s'")" "$LFS_USER_BASH_PROFILE"


cat > "$LFS_USER_BASH_PROFILE" << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
if (( $? )); then
    abort "$(gettext "Couldn't create LFS_USER_BASH_PROFILE: '%s'")" "$LFS_USER_BASH_PROFILE"
fi


plain_i "$(gettext "Creating LFS_USER_BASHRC      : '%s'")" "$LFS_USER_BASHRC"
cat > "$LFS_USER_BASHRC" << EOF
set +h
umask 022
LFS=$LFS
LC_ALL=POSIX
LFS_TGT=$ARCH-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF
if (( $? )); then
    abort "$(gettext "Couldn't create LFS_USER_BASHRC: '%s'")" "$LFS_USER_BASHRC"
fi


plain_i "$(gettext "Creating LFS_USER_LOGS_DIR    : '%s'...")" "$LFS_USER_LOGS_DIR"
mkdir -p $LFS_USER_LOGS_DIR || abort "$(gettext "Couldn't create LFS_USER_LOGS_DIR: '%s'")" "$LFS_USER_LOGS_DIR"


#************************************************************************************************************************
# End of file
#************************************************************************************************************************
