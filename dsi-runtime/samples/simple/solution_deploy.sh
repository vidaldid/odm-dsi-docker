#!/bin/bash

# This script deploys the solution simple and the associated connectivity
# configuration.
#
# The first argument is the installation directory of ODM Insights
# The second argument is the hostname of the DSI Runtime.
# The third argument is the port of the DSI Runtime.

set -e

function print_usage {
        echo "USAGE: $0 <DSI_HOME> <DSI_HOSTNAME> <DSI_PORT>"
}

if [ -z "$1" ]; then
        print_usage
        exit 1
else
        DSI_HOME="$1"
fi

if [ -z "$2" ]; then
        print_usage
        exit 1
else
        DSI_HOSTNAME="$2"
fi

if [ -z "$3" ]; then
        DSI_PORT="9443"
else
        DSI_PORT="$3"
fi

SRC_DIR=`dirname $0`
ESA="$SRC_DIR/simple_solution-0.0.esa"
INCONN="$SRC_DIR/in-connectivity-server-configuration.xml"

SOL_MANAGER_OPTS="--sslProtocol=TLSv1.2 --disableServerCertificateVerification=true --disableSSLHostnameVerification=true --username=tester --password=tester"
DSI_HOME_BIN="$DSI_HOME/runtime/ia/bin"

$DSI_HOME_BIN/solutionManager deploy remote $ESA $SOL_MANAGER_OPTS --host=$DSI_HOSTNAME --port=$DSI_PORT

$DSI_HOME_BIN/connectivityManager deploy remote $ESA $INCONN $SOL_MANAGER_OPTS --host=$DSI_HOSTNAME --port=$DSI_PORT
