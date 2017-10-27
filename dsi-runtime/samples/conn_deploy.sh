#!/bin/bash

# This script deploys the connectivity configuration.
#
# USAGE: $0 <DSI_HOME> <DSI_HOSTNAME> <DSI_PORT> <ESA> <CONFIG_XML>

# DSI_HOME is the installation directory of ODM Insights
# DSI_HOSTNAME is the hostname of the DSI Runtime.
# DSI_PORT is the port of the DSI Runtime.
# ESA the path to the .esa file of the solution
# CONFIG_XML the path to the configuration file of the solution connectivity.

set -e

function print_usage {
        echo "USAGE: $0 <DSI_HOME> <DSI_HOSTNAME> <DSI_PORT> <ESA> <CONFIG_XML>"
}

if [ -z "$5" ]; then
        print_usage
        exit 1
else
        DSI_HOME="$1"
        DSI_HOSTNAME="$2"
        DSI_PORT="$3"
        ESA="$4"
        CONN="$5"
fi

SRC_DIR=`dirname $0`

SOL_MANAGER_OPTS="--sslProtocol=TLSv1.2 --disableServerCertificateVerification=true --disableSSLHostnameVerification=true --username=tester --password=tester"
DSI_HOME_BIN="$DSI_HOME/runtime/ia/bin"

$DSI_HOME_BIN/connectivityManager deploy remote $ESA $CONN $SOL_MANAGER_OPTS --host=$DSI_HOSTNAME --port=$DSI_PORT
