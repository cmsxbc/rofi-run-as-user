#! /bin/bash
# This script based on the answer from Matija Nalis
# https://unix.stackexchange.com/questions/108784/running-gui-application-as-another-non-root-user/543556#543556
# 

set -e

function run() {
    set +e
    xhost +"${AUTHSTRING}" > /dev/null
    # shellcheck disable=SC2086
    sudo -k --askpass -u "${AUTHUSER}" ${APPLICATION_CMD}
    xhost -"${AUTHSTRING}" > /dev/null
    sudo -K
}


function usage() {
    echo "$0 <application> [user]"
}


[[ "$1" == "" ]] && usage  && exit 1;


if [[ "$1" == "-u" ]];then
    AUTHUSER="$2"
    shift 2;
elif [[ "$1" =~ "-u" ]];then
    AUTHUSER="${1/-u/}"
    shift 1;
fi


APPLICATION="$(which -- "$1")"
APPLICATION_CMD="$*"

[[ "$APPLICATION" == "" ]] && echo "Unknown application: $1" >&2 && exit 1


if [[ "$AUTHUSER" == "" ]];then
    APPLICATION_NAME="$(basename "$APPLICATION")"
    if [[ "$RUN_GUI_AS_FORCE_APPLICATION_USER" = "1" ]]; then
        if ! grep -q "$APPLICATION_NAME" /etc/passwd ;then
            # shellcheck disable=SC2086
            rofi $RUN_GUI_AS_ROFI_ARGS -e "User '${APPLICATION_NAME}' does not exist!"
            exit 1
        fi
        AUTHUSER="$APPLICATION_NAME"
    elif [[ "$RUN_GUI_AS_NOLOGIN" = "" ]];then
        # shellcheck disable=SC2086
        AUTHUSER="$(grep -v nologin /etc/passwd | cut -d ':' -f 1 | rofi -dmenu -no-fixed-num-lines -p 'Run as user' -select "$APPLICATION_NAME" $RUN_GUI_AS_ROFI_ARGS)"
    else
        # shellcheck disable=SC2086
        AUTHUSER="$(cut -d ':' -f 1 /etc/passwd | rofi -dmenu -no-fixed-num-lines -p 'Run as user' -select "$APPLICATION_NAME" $RUN_GUI_AS_ROFI_ARGS)"
    fi
fi


[[ "$SUDO_ASKPASS" == "" ]] && export SUDO_ASKPASS=askpass-rofi.sh


AUTHSTRING=SI:localuser:${AUTHUSER}
echo "RUN '$APPLICATION_CMD' AS '$AUTHUSER'"

run
