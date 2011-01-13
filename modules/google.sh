function cmd_google(){
    if [ "$1" == "suggest" ]; then
        cmd_gsuggest ${@:1}
        return
    fi

    query=$(echo $@ | tr ' ' '+')
    url="http://google.com/search?q=${query}"
    privmsg "$RECIP" "$SENDER_NICK: $url"
}

function cmd_gsuggest(){
    query=$(echo $@ | tr ' ' '+')
    url="http://suggestqueries.google.com/complete/search?client=firefox&q=${query}"
    page=`wget -O- $url`
    result=$(echo $page | sed -e 's/\[\"[^"]*\"\,\[\"//' | sed -e s/\"\]\]//)
    result=$(echo $result | sed -e 's/\"\,\"/\,\ /g')
    reply "$SENDER_NICK: You may be looking for: $result"
}
