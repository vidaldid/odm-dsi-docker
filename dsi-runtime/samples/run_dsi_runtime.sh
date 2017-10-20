#!/bin/bash

# Example of a typical creation of a docker container for DSI runtime.
#
# A dedicated volume should be created before:
# docker volume create --name dsi-runtime
#

docker run -p9443:9443 -vdsi-runtime:/opt/dsi/runtime/wlp --name dsi-runtime dsi-runtime /root/start.sh $*
