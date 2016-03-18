#************************************************************************************************************************
#
#   P-Linux COMMON SHELL FUNCTIONS: https://github.com/P-Linux/
#   Copyright (c) 2016, **peter1000** <https://github.com/peter1000> (License GPL2 or later)
#
#   * USAGE with in a shell script: source this file within your shell script
#                                 To use 'interrupted' set a trap
#
#   * EXAMPLE
#
#       if [ -z "$BASH" ]; then printf "\nERROR SHELL: '%s' SCRIPT needs 'bash'\n\n" "$(ps -p $$ -ocomm=)"; exit 1; fi
#       THIS_SCRIPT_PATH="$(readlink -f "$(type -P $0 || echo $0)")"
#       THIS_SCRIPT_DIR="$(dirname "$THIS_SCRIPT_PATH")"
#       source $THIS_SCRIPT_DIR/../p_linux_common_func.sh
#       trap "interrupted" SIGHUP SIGINT SIGQUIT SIGTERM
#       msg_format
#       check_have_gettext  $THIS_SCRIPT_PATH
#       
#       get_user_permission_to_run "root"
#
#************************************************************************************************************************


#************************************************************************************************************************
#
#   MESSAGES FUNCTIONS - functions for outputting messages.
#
#   * USAGE EXAMPLE - MESSAGE FORMAT: To support translation the messages format should be:
#
#       plain "$(gettext "Some Info...")"
#       plain "$(gettext "The files path is: %s")"  "$FILEPATH"
#       plain "$(gettext "Source file:  %s")" "$(get_filename "$1")"
#
#************************************************************************************************************************

msg_format() {
	if tput setaf 0 &>/dev/null; then
		ALL_OFF_MSG="$(tput sgr0)"
		BOLD_MSG="$(tput bold)"
		RED_MSG="${BOLD_MSG}$(tput setaf 1)"
		GREEN_MSG="${BOLD_MSG}$(tput setaf 2)"
		YELLOW_MSG="${BOLD_MSG}$(tput setaf 3)"
		BLUE_MSG="${BOLD_MSG}$(tput setaf 4)"
		MAGENTA_MSG="${BOLD_MSG}$(tput setaf 5)"
	else
		ALL_OFF_MSG="\e[0m"
		BOLD_MSG="\e[1m"
        RED_MSG="${BOLD_MSG}\e[31m"
		GREEN_MSG="${BOLD_MSG}\e[32m"
		YELLOW_MSG="${BOLD_MSG}\e[33m"
		BLUE_MSG="${BOLD_MSG}\e[34m"
		MAGENTA_MSG="${BOLD_MSG}\e[35m"
	fi
}


plain() {
	local MESG=$1; shift
	printf "${BOLD_MSG}====> ${MESG}${ALL_OFF_MSG}\n" "$@" >&1
}

plain_i() {
	local MESG=$1; shift
	printf "${BOLD_MSG}       ${MESG}${ALL_OFF_MSG}\n" "$@" >&1
}

plain2() {
	local MESG=$1; shift
	printf "${BOLD_MSG}    ====> ${MESG}${ALL_OFF_MSG}\n" "$@" >&1
}

plain2_i() {
	local MESG=$1; shift
	printf "${BOLD_MSG}           ${MESG}${ALL_OFF_MSG}\n" "$@" >&1
}

msg() {
	local MESG=$1; shift
	printf "${GREEN_MSG}====>${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n" "$@" >&1
}

msg_i() {
	local MESG=$1; shift
	printf "${BLUE_MSG}    ->${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n" "$@" >&1
}

msg2() {
	local MESG=$1; shift
	printf "${GREEN_MSG}    ====>${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n" "$@" >&1
}

msg2_i() {
	local MESG=$1; shift
	printf "${BLUE_MSG}        ->${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n" "$@" >&1
}


warning() {
	local MESG=$1; shift
	printf "${YELLOW_MSG}====> $(gettext "WARNING:")${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n" "$@" >&2
}

warning2() {
	local MESG=$1; shift
	printf "${YELLOW_MSG}    ====> $(gettext "WARNING:")${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n" "$@" >&2
}

error() {
	local MESG=$1; shift
	printf "${RED_MSG}====> $(gettext "ERROR:")${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n" "$@" >&2
}

error2() {
	local MESG=$1; shift
	printf "${RED_MSG}    ====> $(gettext "ERROR:")${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n" "$@" >&2
}

abort() {
	local MESG=$1; shift
    printf "${MAGENTA_MSG}\n\n=======> $(gettext "ABORTING....")${ALL_OFF_MSG}\n" >&2
    printf "${RED_MSG}    ->${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n\n" "$@" >&2
    exit 1
}

interrupted() {
    abort "$(gettext "INTERRUPTED")"
}


#*****************************************
#
#   <color_mesg>
#
#   ARGUMENT: 'FORMAT_MSG' SHOULD BE one of the defined variables of function: <msg_format>
#
#   ALL_OFF_MSG, BOLD_MSG, RED_MSG, GREEN_MSG, YELLOW_MSG, BLUE_MSG, MAGENTA_MSG
#
#   * USAGE EXAMPLE
#
#       color_mesg FORMAT_MSG Message-Text
#
#   * EXAMPLE
#
#       color_mesg $GREEN_MSG "$(gettext "The files path is: %s")"  "$FILEPATH"
#
color_mesg() {
    local FORMAT_MSG=$1
    local MESG=$2; shift
    printf "${FORMAT_MSG}${MESG}${ALL_OFF_MSG}\n" "${@:2}" >&1
}


# <color_header>: USAGE EXAMPLE: similar to function <color_mesg>
color_header() {
    local FORMAT_MSG=$1
    local MESG=$2; shift
    
    printf "${FORMAT_MSG}\n" >&1
    printf "#===========================================================================#\n" >&1
    printf "#\n" >&1
    printf "# ${MESG}\n" "${@:2}" >&1
    printf "#\n" >&1
    printf "#===========================================================================#\n" >&1
    printf "${ALL_OFF_MSG}\n" >&1
}

# <color_header>: USAGE EXAMPLE: similar to function <color_mesg>
color_header_i() {
    local FORMAT_MSG=$1
    local MESG=$2; shift
    
    printf "${FORMAT_MSG}\n" >&1
    printf "    #=======================================================================#\n" >&1
    printf "    #\n" >&1
    printf "    # ${MESG}\n" "${@:2}" >&1
    printf "    #\n" >&1
    printf "    #=======================================================================#\n" >&1
    printf "${ALL_OFF_MSG}\n" >&1
}

#*****************************************
#
#   <hrl>
#
#   ARGUMENT: 'FORMAT_MSG' SHOULD BE one of the defined variables of function: <msg_format>
#
#   ALL_OFF_MSG, BOLD_MSG, RED_MSG, GREEN_MSG, YELLOW_MSG, BLUE_MSG, MAGENTA_MSG
#
#   * USAGE EXAMPLE
#
#       hrl FORMAT_MSG 'START_TXT' 'REPEATED_TEXT' REPEAT_NUMBER 'END_TEXT'
# 
#   * EXAMPLE
#
#       hrl $GREEN_MSG '#' '=' 25 '#'
#
#       * OUTPUT: 
#
#           #=========================#
#
hrl() {
    local FORMAT_MSG=$1
    local START_TXT=$2
    local REPEATED_TEXT=$3
    local REPEAT_NUMBER=$4
    local END_TEXT=$5 
    local COMPLETE_LINE=''
    
    while (( ${#COMPLETE_LINE} < $REPEAT_NUMBER )); do 
        COMPLETE_LINE+="$REPEATED_TEXT"; 
    done
    printf "${FORMAT_MSG}%s%s%s${ALL_OFF_MSG}\n" "$START_TXT" "${COMPLETE_LINE:0:REPEAT_NUMBER}" "$END_TEXT" >&1
}


#************************************************************************************************************************
#   DIVERSE FUNCTION
#************************************************************************************************************************

check_have_gettext() {
    local script_path=$1
    if [ ! "$(type -p gettext)" ]; then
        printf "${MAGENTA_MSG}\n====> ABORTING....${ALL_OFF_MSG}\n" >&2
        printf "${BLUE_MSG}    ->${ALL_OFF_MSG}${BOLD_MSG} CAN'T RUN SCRIPT: <%s>${ALL_OFF_MSG}\n\n" "$script_path" >&2
        printf "${YELLOW_MSG}    ->${ALL_OFF_MSG}${BOLD_MSG} MISSING COMMAND: <gettext>${ALL_OFF_MSG}\n\n" >&2
        exit 1
    fi
}


#*****************************************
#
#   <get_user_permission_to_run>
#
#   General request for a manual input of the user.
#
#   Optional Argument $1: 'CHECK_USER' name under which the script must run
#
#   * USAGE EXAMPLE
#
#       get_user_permission_to_run
#       get_user_permission_to_run "root"
# 
#
get_user_permission_to_run() {
    local CHECK_USER=$1

    local MSG1="$(gettext "This script MUST run under User-Account: '%s'")"
    local MSG2="$(gettext "INFO: Please run this script in %sMAXIMIZED%s terminal.")"
    local MSG3="$(gettext "To %sINTERRUPT%s at any time press [%sctrl+c%s].")"
    local MSG4="$(gettext "To %sCONTINUE%s type: [%sYES%s]: ")"


    echo 
    if [[ -n "$CHECK_USER" ]]; then
        if [[ "$(whoami)" != "$CHECK_USER" ]]; then
            printf "${BLUE_MSG}        ${MSG1}${ALL_OFF_MSG}\n" "$CHECK_USER" >&1
            abort "$(gettext "Got EUID: '%s' USER: '%s'")" "$EUID" "$(whoami)"
        fi
    fi
	printf "${GREEN_MSG}====> ${ALL_OFF_MSG}${MSG2}\n" "$BOLD_MSG" "$ALL_OFF_MSG" >&1
    printf "        ${MSG3}\n\n" "$BOLD_MSG" "$ALL_OFF_MSG" "$GREEN_MSG" "$ALL_OFF_MSG" >&1
    printf "                ${MSG4}" "$BOLD_MSG" "$ALL_OFF_MSG" "$GREEN_MSG" "$ALL_OFF_MSG" >&1
    read USER_INPUT
    [[ "$USER_INPUT" == 'YES' ]] || exit 1
    echo
}

get_basename() {
    printf "%s\n" "${1##*/}"
}


#************************************************************************************************************************
# End of file
#************************************************************************************************************************
