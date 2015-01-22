#!/bin/bash

if [ x$1 = x ]; then
	echo "Usage: bpdchecker.sh EGN" >&2
	exit 100
fi

EGN=$1
LOGFILE=$(dirname $0)/bpdchecker.log
NOT_RECEIVED="След 29.03.2010 г. лицето с ЕГН $EGN няма издаден документ от избрания вид или същият вече е получен."
DATE=$(date +"[%Y-%m-%d %T]")

OUTPUT=$(curl -s --data "__Click=C2257C590038004D.a1a096ff9bbd6b84c22572a3005638f0%2F%24Body%2F0.1336&%25%25Surrogate_TypeDoc=1&TypeDoc=6733&Number=$EGN" \
https://izdadeni.mvr.bg/nld2/nWeb2.nsf/fVerification?OpenForm\&Seq=1 | grep "system-message" | cut -d ">" -f 3 | cut -d "<" -f 1 | tr -d "[]")

echo $DATE "$OUTPUT" >> $LOGFILE

if [ "$OUTPUT" != "$NOT_RECEIVED" ]; then
	echo "$OUTPUT" | mail -s "Издаден документ - СУМПС" plamenkinev@gmail.com
fi
