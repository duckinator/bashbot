#!/bin/bash

INIT_CHANNELS="##eleventhbit"
NICK="BashBot"
SERVER="irc.freenode.net/6667"

source ./modules/functions.sh
source ./modules/commands.sh
source ./modules/google.sh

socket $SERVER
init $NICK "$NICK 0 0 :BashBot v$VERSION by duckinator"

while true; do
	recv
done
