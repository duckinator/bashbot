VERSION="0.01"

function socket(){
    # Connects to $1 on file descriptor 3
    # $1 should be in the form of server/port
    exec 3<>/dev/tcp/$1
}

function raw(){
    echo "<< ${@}"
    echo "${@}">&3
}

function init(){
    # Sends 'NICK $1\nUSER $2'
    raw "NICK $1"
    raw "USER $2"
}

function join(){
    raw "JOIN $1"
}

function part(){
    raw "PART $1"
}

function quit(){
    raw "QUIT $1"
}

function privmsg(){
    # PRIVMSG who :what
    raw "PRIVMSG $1 :$2"
}

function reply(){
    raw "$TYPE $RECIP :$@"
}

function notice(){
    # NOTICE who :what
    raw "NOTICE $1 :$2"
}

function ctcp(){
    # PRIVMSG who :\001<type> <params>
    notice $1 "$(echo -e '\001')$(echo $2 | tr '[:lower:]' '[:upper:]') ${@:3}$(echo -e '\001')"
}

function recv(){
    while true; do
        read RECV<&3
        if [ $? == 0 ]; then
            break
        fi
        sleep 0.1
    done
    RECV="$(echo $RECV | sed 's/\\/\\\\/g' | sed 's/\n//g' | sed 's/\r//g')"
    
    SENDER=($(echo $RECV | awk -F" " '{print $1}'))
    SENDER=${SENDER#:*}
    SENDER_NICK=($(echo $SENDER | awk -F'!' '{print $1}'))
    TYPE=($(echo $RECV | awk -F" " '{print $2}'))
    RECIP=($(echo $RECV | awk -F" " '{print $3}'))
    if [ "$RECIP" == "$NICK" ]; then
        RECIP=$SENDER_NICK
    fi

    MESSAGE=$RECV
    for ((i=0; i<3; i++)); do
        MESSAGE=${MESSAGE#* }
    done
    MESSAGE=${MESSAGE#:*}
    if [ "$TYPE" == "PRIVMSG" ]; then
        if [ "${MESSAGE:0:1}" == "$(echo -e '\001')" ]; then
            if [ "${MESSAGE:(-1):1}" == "$(echo -e '\001')" ]; then
                MESSAGE=${MESSAGE:1:$((${#MESSAGE}-2))}
                if [[ $MESSAGE =~ ' ' ]]; then
                    pos=$((`expr index "$MESSAGE" ' '`-1)) # Position of first space, minus one so we don't /include/ that space
                    CTCP_TYPE=${MESSAGE:0:$pos}
                    CTCP_PARAM=${MESSAGE#* }
                else
                    CTCP_TYPE=$MESSAGE
                    CTCP_PARAM=
                fi
                onctcp
                continue;
            fi
        fi
    elif [ "$TYPE" == "001" ]; then
        join $INIT_CHANNELS
    fi
    COMMAND=($(echo $MESSAGE | awk -F"^$NICK[:, ] ?* *" '{print $2}'))
    COMMAND_PARAM="$MESSAGE"
    for ((i=0; i<2; i++)); do
        COMMAND_PARAM=${COMMAND_PARAM#* }
    done

    echo ">> $RECV"

    onrecv
}

function onrecv(){
    # PING/PONG
    if [ "$SENDER" == "PING" ]; then
        raw "PONG $(echo $RECV | awk -F"PING " '{print $2}')"
        continue;
    fi

    if [ "$COMMAND" != "" ]; then
        COMMAND_CHECK="$(echo $COMMAND | sed -e 's/[^[:alnum:]]//g')"
        if [ "$COMMAND" != "$COMMAND_CHECK" ]; then
            privmsg "$RECIP" "$SENDER_NICK: Invalid command $COMMAND ($COMMAND_CHECK)."
        else
            cmd_$COMMAND $COMMAND_PARAM
        fi
    fi

}

function onctcp(){
    case "$CTCP_TYPE" in
    "VERSION")
        ctcp "$SENDER_NICK" "VERSION" "BashBot $VERSION running on $(uname --operating-system) [$(uname --machine --processor)]"
        ;;
    "PING")
        ctcp "$SENDER_NICK" "PING" "$CTCP_PARAM"
        ;;
    esac
}
