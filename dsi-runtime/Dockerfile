FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y dist-upgrade

COPY opt /opt

COPY start.sh /root/

CMD /root/start.sh
