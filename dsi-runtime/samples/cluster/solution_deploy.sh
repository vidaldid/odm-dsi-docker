#!/bin/bash

set -e

function print_usage {
        echo "USAGE: $0 <DSI_HOME>"
}

function get_ip {
        echo `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1`
}

if [ -z "$1" ]; then
        print_usage
        exit 1
fi

DSI_HOME="$1"

SRC_DIR=`dirname $0`

ESA="$SRC_DIR/simple_solution-0.0.esa"
INCONN="$SRC_DIR/in-connectivity-server-configuration.xml"

CONTAINER1=`get_ip dsi-runtime-container1`
CONTAINER2=`get_ip dsi-runtime-container2`
CONTAINER3=`get_ip dsi-runtime-container3`
INBOUND=`get_ip dsi-runtime-inbound`

echo "CONTAINER1=$CONTAINER1"
echo "CONTAINER2=$CONTAINER2"
echo "CONTAINER3=$CONTAINER3"

SOL_DEPLOY="$SRC_DIR/../solution_deploy.sh"

$SOL_DEPLOY $DSI_HOME $CONTAINER1 9443 $ESA
$SOL_DEPLOY $DSI_HOME $CONTAINER2 9443 $ESA
$SOL_DEPLOY $DSI_HOME $CONTAINER3 9443 $ESA

CONN_DEPLOY="$SRC_DIR/../conn_deploy.sh"

$CONN_DEPLOY $DSI_HOME $INBOUND 9443 $ESA $INCONN
