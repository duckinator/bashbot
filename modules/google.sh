function cmd_google(){
  query=$(echo $@ | tr ' ' '+')
  url="http://google.com/search?q=${query}"
  privmsg "$RECIP" "$SENDER_NICK: $url"
}

function cmd_google_suggest(){
  query=$(echo $@ | tr ' ' '+')
  url="http://suggestqueries.google.com/complete/search?client=firefox&q=${query}"
  page=`wget -O- $url`
  result=$(echo $page | sed -e 's/\[\"[^"]*\"\,\[\"//' | sed -e s/\"\]\]//)
  result=$(echo $result | sed -e 's/\"\,\"/\,\ /g')
  privmsg "$RECIP" "$SENDER_NICK: You may be looking for: $result"
}

function cmd_gsuggest(){
  cmd_google_suggest $@
}

