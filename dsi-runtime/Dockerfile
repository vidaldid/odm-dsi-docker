ARG baseimg

FROM $baseimg

RUN apt-get update
RUN apt-get -y dist-upgrade

COPY start.sh /root/

RUN mkdir -p /opt
ADD /opt /opt

RUN sed -i "s/\/bin\/sh/\/bin\/bash/g" "/opt/dsi/runtime/wlp/bin/xscmd.sh"

CMD /root/start.sh
