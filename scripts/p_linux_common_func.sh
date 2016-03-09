#************************************************************************************************************************
#
#   P-Linux COMMON SHELL FUNCTIONS: **peter1000**
#
#
#   USAGE with in a shell script: source this file within your shell script
#                                 To use 'interrupted' set a trap
#
#       EXAMPLE:
#
#       if [ -z "$BASH" ]; then printf "\nWRONG SHELL: '%s' SCRIPT needs 'bash'\n\n" "$(ps -p $$ -ocomm=)"; exit 1; fi
#       THIS_SCRIPT_PATH="$(readlink -f "$(type -P $0 || echo $0)")"
#       THIS_SCRIPT_DIR="$(dirname "$THIS_SCRIPT_PATH")"
#       source $THIS_SCRIPT_DIR/../p_linux_common_func.sh
#       trap "interrupted" SIGHUP SIGINT SIGQUIT SIGTERM
#       msg_format
#       check_have_gettext  $THIS_SCRIPT_PATH
#
#
#************************************************************************************************************************

#************************************************************************************************************************
#
#   MESSAGES FUNCTIONS - functions for outputting messages.
#
# USAGE EXAMPLE - MESSAGE FORMAT: To support translation the messages format should be:
#
#   plain "$(gettext "Some Info...")"
#   plain "$(gettext "The files path is: %s")"  "$FILEPATH"
#   plain "$(gettext "Source file <%s>.")" "$(get_filename "$1")"
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
    printf "${MAGENTA_MSG}\n=======> $(gettext "ABORTING....\n")${ALL_OFF_MSG}" >&2
    printf "${BLUE_MSG}    ->${ALL_OFF_MSG}${BOLD_MSG} ${MESG}${ALL_OFF_MSG}\n\n" "$@" >&2
    exit 1
}

interrupted() {
    printf "${RED_MSG}\n======> $(gettext "ERROR:")${ALL_OFF_MSG}${BOLD_MSG} Interrupted${ALL_OFF_MSG}\n" >&2
	exit 1
}


#*****************************************
#
#   Color Message
#
#   ARGUMENT: 'FORMAT_MSG' SHOULD BE one of the defined variables of function: <msg_format>
#
#   ALL_OFF_MSG, BOLD_MSG, RED_MSG, GREEN_MSG, YELLOW_MSG, BLUE_MSG, MAGENTA_MSG
#
# USAGE EXAMPLE
#
#   color_mesg FORMAT_MSG Message-Text
# 
#    EXAMPLE:
#
#  color_mesg $GREEN_MSG "$(gettext "The files path is: %s")"  "$FILEPATH"
#
color_mesg() {
    local FORMAT_MSG=$1
    local MESG=$2; shift
    printf "${FORMAT_MSG}${MESG}${ALL_OFF_MSG}\n" "${@:2}" >&1
}


# color_header: USAGE EXAMPLE: similar to function <color_mesg>
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

# color_header: USAGE EXAMPLE: similar to function <color_mesg>
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
#   Horizontal Line
#
#   ARGUMENT: 'FORMAT_MSG' SHOULD BE one of the defined variables of function: <msg_format>
#
#   ALL_OFF_MSG, BOLD_MSG, RED_MSG, GREEN_MSG, YELLOW_MSG, BLUE_MSG, MAGENTA_MSG
#
# USAGE EXAMPLE
#
#   hrl FORMAT_MSG 'START_TXT' 'REPEATED_TEXT' REPEAT_NUMBER 'END_TEXT'
# 
#    EXAMPLE:
#
#  hrl $GREEN_MSG '#' '=' 80 '#'
#
#   OUTPUT: #=========================#
#
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
        printf "${MAGENTA_MSG}\n====> ABORTING....\n${ALL_OFF_MSG}" >&2
        printf "${BLUE_MSG}    ->${ALL_OFF_MSG}${BOLD_MSG} CAN'T RUN SCRIPT: <%s>${ALL_OFF_MSG}\n\n" "$script_path" >&2
        printf "${YELLOW_MSG}    ->${ALL_OFF_MSG}${BOLD_MSG} MISSING COMMAND: <gettext>${ALL_OFF_MSG}\n\n" >&2
        exit 1
    fi
}


#************************************************************************************************************************
# End of file
#************************************************************************************************************************
