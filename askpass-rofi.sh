#!/bin/sh
# This script is copied from 
# https://github.com/davatorium/rofi/issues/584#issuecomment-384555551


# Take password prompt from STDIN, print password to STDOUT
# the sed piece just removes the colon from the provided
# prompt: rofi -p already gives us a colon
rofi -dmenu -password -no-fixed-num-lines -p "$(echo "$1" | sed s/://)"
