#!/bin/bash

# This script is called at build time to update /opt/dsi/runtime/wlp/etc/server.env
# and point to the right JAVA_HOME.


set -e

DSI_HOME="/opt/dsi"

if [ -z "$JAVA_HOME" ]; then
        export JAVA_HOME="$DSI_HOME/jdk/jre"
fi

echo "JAVA_HOME=$JAVA_HOME"


echo "JAVA_HOME=$JAVA_HOME" > /opt/dsi/runtime/wlp/etc/server.env

