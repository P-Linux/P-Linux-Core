#!/bin/bash

#************************************************************************************************************************
# HELPER FUNCTIONS
#************************************************************************************************************************

check_library_consistency() {
    local lib
    local PRESENT=0
    local ABSENT=0
    for lib in lib{gmp,mpfr,mpc}.la; do
        if $(find /usr/lib* -name $lib| grep -q $lib); then
            plain2 "$(gettext "%s: found")" "$lib"
            (( PRESENT++ ))
        else
            plain2 "$(gettext "%s: not found")" "$lib"
            (( ABSENT++ ))
        fi
    done

    
    echo
    msg "$(gettext "NOTE....")"

    color_header_i $MAGENTA_MSG "$(gettext "The files identified by this script should be all PRESENT\n%s")" \
                                "    #            or all ABSENT, but not only one or two present." 
                     
    color_mesg $YELLOW_MSG "$(gettext "      Library consistency: PRESENT: '%s' ABSENT: '%s'\n\n")" "$PRESENT" "$ABSENT"

    if (( PRESENT > 0 )) && (( ABSENT > 0 )); then
         abort "$(gettext "Problems with library consistency: PRESENT: '%s' ABSENT: '%s'")" "$PRESENT" "$ABSENT"
    fi           
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

color_header $GREEN_MSG "$(gettext "Checking for some library consistency...")"

check_library_consistency


#************************************************************************************************************************
# End of file
#************************************************************************************************************************
