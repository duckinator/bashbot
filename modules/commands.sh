function cmd_say(){
	privmsg "$RECIP" "$SENDER_NICK: $@"
}

function cmd_join(){
	join "$@"
}

function cmd_load(){
	MOD_NAME=$1
	MOD_LOCATION="./modules/$(echo $MOD_NAME | sed 's/\///g' | sed 's/\\//g').sh"
	if [ -f $MOD_LOCATION ]; then
		source $MOD_LOCATION
		privmsg "$RECIP" "$SENDER_NICK: Loaded module $MOD_NAME"
	else
		privmsg "$RECIP" "$SENDER_NICK: No such module $MOD_NAME"
	fi
}

function cmd_test(){
	privmsg "$RECIP" "IT LIVES!"
}

function cmd_uptime(){
	privmsg "$RECIP" "$SENDER_NICK: $(uptime)"
}

function cmd_uname(){
	privmsg "$RECIP" "$SENDER_NICK: $(uname -a)"
}
