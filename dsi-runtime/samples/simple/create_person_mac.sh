#!/bin/bash

set -e

function print_usage {
        echo "USAGE: $0 <DSI_HOSTNAME> <PERSON_NAME>"
}

if [ -z "$1" ]; then
        print_usage
        exit 1
else
        DSI_HOSTNAME="$1"
fi

if [ -z "$2" ]; then
        PERSON="john"
else
        PERSON="$2"
fi

cp ./create_person.xml /tmp/$$.tmp

sed -i '' -e "s/ID/$PERSON/" /tmp/$$.tmp

URL=https://$DSI_HOSTNAME:9443/in/simple

echo "Endpoint URL: $URL"

cat /tmp/$$.tmp

curl -k -H "Content-Type: application/xml" -d @/tmp/$$.tmp -X POST $URL

rm /tmp/$$.tmp
