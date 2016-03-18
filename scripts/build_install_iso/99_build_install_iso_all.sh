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

get_user_permission_to_run "$(gettext "            This script MUST run with root privileges!!!")"

if ! (( EUID == 0 )); then
    color_mesg $BLUE_MSG "$(gettext "This script MUST run with root privileges: EUID <0>.")"
    abort "$(gettext "Got EUID: '%s' USER: '%s'")" "$EUID" "$(whoami)"
fi
#==================================================================================

color_header $GREEN_MSG "$(gettext "Running: all automated scripts to: 'Build A P-Linux Install ISO'...")"

source $THIS_SCRIPT_DIR/02_setting_common_variables.sh
source $THIS_SCRIPT_DIR/03_general_preparation.sh

source $THIS_SCRIPT_DIR/04_optional_preparation.sh
source $THIS_SCRIPT_DIR/05_download_sources.sh

echo
