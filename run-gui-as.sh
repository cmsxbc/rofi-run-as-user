#! /bin/bash
# This script based on the answer from Matija Nalis
# https://unix.stackexchange.com/questions/108784/running-gui-application-as-another-non-root-user/543556#543556
# 

set -e

function run() {
    set +e
    xhost +"${AUTHSTRING}" > /dev/null
    sudo -k --askpass -u "${AUTHUSER}" "${APPLICATION}"
    xhost -"${AUTHSTRING}" > /dev/null
    sudo -K
}


function usage() {
    echo "$0 <application> [user]"
}


[[ "$1" == "" ]] && usage  && exit 1;

APPLICATION="$(which -- "$1")"

[[ "$APPLICATION" == "" ]] && echo "Unknown application: $1" >&2 && exit 1


if [[ "$2" == "" ]];then
    APPLICATION_NAME="$(basename "$APPLICATION")"
    if [[ "$RUN_GUI_AS_NOLOGIN" = "" ]];then
        AUTHUSER="$(grep -v nologin /etc/passwd | cut -d ':' -f 1 | rofi -dmenu -no-fixed-num-lines -p 'Run as user' -select "$APPLICATION_NAME")"
    else
        AUTHUSER="$(cut -d ':' -f 1 /etc/passwd | rofi -dmenu -no-fixed-num-lines -p 'Run as user' -select "$APPLICATION_NAME")"
    fi
else
    AUTHUSER="$2"
fi


[[ "$SUDO_ASKPASS" == "" ]] && export SUDO_ASKPASS=askpass-rofi.sh


AUTHSTRING=SI:localuser:${AUTHUSER}
echo "RUN '$APPLICATION' AS '$AUTHUSER'"

run
