FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y dist-upgrade

COPY opt /opt

RUN sed -i "s/\/bin\/sh/\/bin\/bash/g" "/opt/dsi/runtime/wlp/bin/xscmd.sh"

COPY start.sh /root/

CMD /root/start.sh
