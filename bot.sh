#!/bin/bash

INIT_CHANNELS="#bots"
NICK="BashBot"
SERVER="irc.eighthbit.net/6667"

source ./modules/functions.sh;
source ./modules/commands.sh;

socket $SERVER
init $NICK "$NICK 0 0 :BashBot v$VERSION by duckinator as $NICK"
join $INIT_CHANNELS


while true; do
	recv
done
