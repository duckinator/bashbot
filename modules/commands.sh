function cmd_say(){
    privmsg "$RECIP" "$SENDER_NICK: $@"
}

function cmd_join(){
    join "$@"
}

function cmd_load(){
    MOD_NAME="$(basename $1)"
    MOD_LOCATION="./modules/${MOD_NAME}.sh"
    if [ -f $MOD_LOCATION ]; then
        source $MOD_LOCATION
        reply "$SENDER_NICK: Loaded module $MOD_NAME"
    else
        reply "$SENDER_NICK: No such module $MOD_NAME"
    fi
}

function cmd_test(){
    reply "IT LIVES!"
}

function cmd_uptime(){
    reply "$SENDER_NICK: $(uptime)"
}

function cmd_uname(){
    reply "$SENDER_NICK: $(uname -a)"
}

function cmd_source(){
    reply "My source is available on github at http://github.com/duckinator/bashbot"
}

