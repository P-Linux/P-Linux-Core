#!/bin/bash

#************************************************************************************************************************
# HELPER FUNCTIONS
#************************************************************************************************************************

check_bash() {
    msg "$(gettext "Checking: Bash")"
    plain_i "$(gettext "bash: %s")" "$(bash --version | head -n1 | cut -d" " -f2-4)"

    msg_i "$(gettext "/bin/sh should be a symbolic or hard link to bash")"
    local MYSH=$(readlink -f /bin/sh)
    if $(echo $MYSH | grep -q bash); then
        plain_i "$(gettext "/bin/sh -> %s is a link")" "$MYSH"
    else
        error2 "$(gettext "/bin/sh does not point to bash")"
    fi
}

check_bison() {
    msg "$(gettext "Checking: Bison")"
    plain_i "$(gettext "bison: %s")" "$(bison --version | head -n1)"

    msg_i "$(gettext "/usr/bin/yacc should be a link to bison or small script that executes bison")"
    if [ -h /usr/bin/yacc ]; then
        plain_i "$(gettext "/usr/bin/yacc -> %s")" "$(readlink -f /usr/bin/yacc)"
    elif [ -x /usr/bin/yacc ]; then
        plain_i "$(gettext "yacc is %s")" "$(/usr/bin/yacc --version | head -n1)"
    else
        error2 "$(gettext "/usr/bin/yacc not found")"
    fi
}

check_gawk() {
    msg "$(gettext "Checking: Gawk")"
    plain_i "$(gettext "gawk: %s")" "$(gawk --version | head -n1)"

    msg_i "$(gettext "/usr/bin/awk should be a link to gawk")"
    if [ -h /usr/bin/awk ]; then
         plain_i "$(gettext "/usr/bin/awk -> %s")" "$(readlink -f /usr/bin/awk)"
    elif [ -x /usr/bin/awk ]; then
      plain_i "$(gettext "awk is %s")" "$(/usr/bin/awk --version | head -n1)"
    else
        error2 "$(gettext "/usr/bin/awk not found")"
    fi
}

check_gcc() {
    msg "$(gettext "Checking: Gcc (including the C++ compiler)")"
    plain_i "$(gettext "gcc: %s")" "$(gcc --version | head -n1)"
    plain_i "$(gettext "g++: %s")" "$(g++ --version | head -n1)"

    msg_i "$(gettext "Testing g++ compilation")"

    echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
    if [ -x dummy ]; then
        plain_i "$(gettext "g++ compilation: OK")"
    else
        error2 "$(gettext "g++ compilation: FAILED")"
    fi
    rm -f dummy.c dummy
}


#************************************************************************************************************************
#   MAIN VERSION LISTING
#************************************************************************************************************************

if [ -z "$BASH" ]; then printf "\nWRONG SHELL: '%s' SCRIPT needs 'bash'\n\n" "$(ps -p $$ -ocomm=)"; exit 1; fi
THIS_SCRIPT_PATH="$(readlink -f "$(type -P $0 || echo $0)")"
THIS_SCRIPT_DIR="$(dirname "$THIS_SCRIPT_PATH")"
source $THIS_SCRIPT_DIR/../p_linux_common_func.sh
trap "interrupted" SIGHUP SIGINT SIGQUIT SIGTERM
msg_format
check_have_gettext  $THIS_SCRIPT_PATH

export LC_ALL=C


color_header $GREEN_MSG "$(gettext "Listing version numbers of critical development tools...")"

check_bash

msg "$(gettext "Checking: Binutils")"
plain_i "$(gettext "binutils: %s")" "$(ld --version | head -n1 | cut -d" " -f3-)"

check_bison

msg "$(gettext "Checking: Bzip2")"
plain_i "$(gettext "bzip2: %s")" "$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-)"

msg "$(gettext "Checking: Coreutils")"
plain_i "$(gettext "coreutils: %s")" "$(chown --version | head -n1 | cut -d")" -f2)"

msg "$(gettext "Checking: Diffutils")"
plain_i "$(gettext "diffutils: %s")" "$(diff --version | head -n1)"

msg "$(gettext "Checking: Findutils")"
plain_i "$(gettext "find: %s")" "$(find --version | head -n1)"

check_gawk

check_gcc

msg "$(gettext "Checking: Glibc")"
plain_i "$(gettext "glibc: %s")" "$(ldd --version | head -n1 | cut -d" " -f2-)"

msg "$(gettext "Checking: Grep")"
plain_i "$(gettext "grep: %s")" "$(grep --version | head -n1)"

msg "$(gettext "Checking: Gzip")"
plain_i "$(gettext "gzip: %s")" "$(gzip --version | head -n1)"

msg "$(gettext "Checking: Linux Kernel")"
plain_i "$(gettext "Linux Kernel: %s")" "$(cat /proc/version))"

msg "$(gettext "Checking: M4")"
plain_i "$(gettext "m4: %s")" "$(m4 --version | head -n1)"

msg "$(gettext "Checking: Make")"
plain_i "$(gettext "make: %s")" "$(make --version | head -n1)"

msg "$(gettext "Checking: Patch")"
plain_i "$(gettext "patch: %s")" "$(patch --version | head -n1)"

msg "$(gettext "Checking: Perl")"
plain_i "$(gettext "perl: %s")" "$(perl -V:version)"

msg "$(gettext "Checking: Sed")"
plain_i "$(gettext "sed: %s")" "$(sed --version | head -n1)"

msg "$(gettext "Checking: Tar")"
plain_i "$(gettext "tar: %s")" "$(tar --version | head -n1)"

msg "$(gettext "Checking: mMkeinfo")"
plain_i "$(gettext "makeinfo: %s")" "$(makeinfo --version | head -n1)"

msg "$(gettext "Checking: Xz")"
plain_i "$(gettext "xz: %s")" "$(xz --version | head -n1)"

msg "$(gettext "Checking: Git")"
plain_i "$(gettext "git: %s")" "$(git --version | head -n1)"

msg "$(gettext "Checking: Wget")"
plain_i "$(gettext "wget: %s")" "$(wget --version | head -n1)"

msg "$(gettext "Checking: Util-linux")"
plain_i "$(gettext "util-linux: %s")" "$(mountpoint --version | head -n1)"


#************************************************************************************************************************
# End of file
#************************************************************************************************************************
