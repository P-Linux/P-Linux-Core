#!/bin/bash

#************************************************************************************************************************
# HELPER FUNCTIONS
#************************************************************************************************************************





#************************************************************************************************************************
#   MAIN CHECKING SOME LIBRARY CONSISTENCY
#************************************************************************************************************************

if [ -z "$BASH" ]; then printf "\nERROR SHELL: '%s' SCRIPT needs 'bash'\n\n" "$(ps -p $$ -ocomm=)"; exit 1; fi
THIS_SCRIPT_PATH="$(readlink -f "$(type -P $0 || echo $0)")"
THIS_SCRIPT_DIR="$(dirname "$THIS_SCRIPT_PATH")"
source $THIS_SCRIPT_DIR/../p_linux_common_func.sh
trap "interrupted" SIGHUP SIGINT SIGQUIT SIGTERM
msg_format
check_have_gettext  $THIS_SCRIPT_PATH

echo
msg "$(gettext "Running: automated 'PASS-1: Constructing a Temporary System'...")"
echo



#************************************************************************************************************************
# End of file
#************************************************************************************************************************
