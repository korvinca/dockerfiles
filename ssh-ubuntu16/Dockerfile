FROM ubuntu:16.04

RUN apt-get update && \
  apt-get -y install -y \
  openssh-server \
  passwd \
  sudo \
  python-simplejson && \
  apt-get clean

ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN chmod 755 /start.sh
EXPOSE 22
RUN ./start.sh
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
