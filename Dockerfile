FROM ubuntu:16.04
MAINTAINER Keith McDuffee <keith@realistek.com>

RUN apt-get update && apt-get install -y \
    auditd \
    docker.io \
    socat \
    xinetd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /root/.docker

COPY xinetd/0-honeypot /etc/xinetd.d/0-honeypot

RUN echo "-a exit,always -F arch=b64 -S execve" > /etc/audit/rules.d/honeypot.rules
RUN echo "-a exit,always -F arch=b32 -S execve" >> /etc/audit/rules.d/honeypot.rules

ENV DOCKER_TLS_VERIFY 1
ENV DOCKER_HOST UNSET

COPY keys/ca.pem /root/.docker/ca.pem
COPY keys/cert.pem /root/.docker/cert.pem
COPY keys/key.pem /root/.docker/key.pem

CMD ["/usr/sbin/xinetd", "-dontfork"]
