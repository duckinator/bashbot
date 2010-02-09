function cmd_asm(){
	OIFS=$IFS
	IFS=';'
	for line in $@; do
		IFS=' '
		i=0
		command=
		arg1=
		arg2=
		for word in $line; do
			if [ $i == 0 ]; then
				command=$word
			elif [ $i == 1 ]; then
				arg1=${word%,}
			elif [ $i == 2 ]; then
				arg2=$word
			fi
			#notice "$SENDER_NICK" "$word"
			i=$[i+1]
		done
		case $(echo $command | tr "[:upper:]" "[:lower:]") in
			"jmp" )
				command="JMP";;
			"je" )
				command="JE";;
			"jne" )
				command="JNE";;
			"cmp" )
				command="CMP";;
			"inc" )
				command="INC";;
			"dec" )
				command="DEC";;
			"xor" )
				command="XOR";;
			"mov" )
				command="MOV";;
			"call" )
				command="CALL";;
			"ret" )
				command="RET";;
			"retn" )
				command="RETN";;
			"retf" )
				command="RETF";;
			*: )
				# Label
				command=$(echo $command | tr "[:lower:]" "[:upper:]");;
			* )
				privmsg "$RECIP" "$SENDER_NICK: Error: No such mnemonic: ${command}."
				return;;
		esac

		if [ "" != "${arg2}" ]; then
		  privmsg "$RECIP" "${command} ${arg1}, ${arg2}"
		else
		  privmsg "$RECIP" "${command} ${arg1}"
		fi
	done
	IFS=$OIFS
	#privmsg "$RECIP" "$SENDER_NICK: $x"
}
