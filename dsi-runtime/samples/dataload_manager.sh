#!/bin/bash

set -e

function print_usage {
        echo "USAGE: $0 <DSI_HOME> <DSI_HOSTNAME> <DATALOAD_MANAGER_CMD>"
}

if [ -z "$1" ]; then
        print_usage
        exit 1
else
        DSI_HOME="$1"
fi

if [ -z "$1" ]; then
        print_usage
        exit 1
else
        DSI_HOSTNAME="$2"
fi


SOL_MANAGER_OPTS="--sslProtocol=TLSv1.2 --disableServerCertificateVerification=true --disableSSLHostnameVerification=true --username=tester --password=tester"
DSI_HOME_BIN="$DSI_HOME/runtime/ia/bin"

$DSI_HOME_BIN/dataLoadManager $SOL_MANAGER_OPTS --host=$DSI_HOSTNAME "${@:3}"
