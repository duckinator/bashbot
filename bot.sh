#!/bin/bash

INIT_CHANNELS="#bots"
NICK="BashBot"
SERVER="irc.eighthbit.net/6667"

source ./functions.sh;
source ./commands.sh;

socket $SERVER
init $NICK "$NICK 0 0 :BashBot v$VERSION by duckinator as $NICK"
join $INIT_CHANNELS


while true; do
	recv
done
