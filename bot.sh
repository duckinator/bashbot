#!/bin/bash

INIT_CHANNELS="#programming"
NICK="BashBot"
SERVER="irc.sinsira.net/6667"

source ./modules/functions.sh
source ./modules/commands.sh
source ./modules/google.sh

socket $SERVER
init $NICK "$NICK 0 0 :BashBot v$VERSION by duckinator as $NICK"
join $INIT_CHANNELS


while true; do
	recv
done
