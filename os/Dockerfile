FROM alpine:3.10
RUN apk add --update docker openrc openssh git vim
RUN rc-update add docker boot


RUN mkdir -p /webapp \
  && mkdir ~/.ssh

COPY ./os/ssh_key/id_rsa.pub /webapp
COPY ./os/ssh_key/id_rsa /webapp


RUN cp /webapp/id_rsa.pub ~/.ssh \
  && cp /webapp/id_rsa ~/.ssh \
  && cd /webapp \
  && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts \
  && git clone git@github.com:sdilshod/drone-ruby.git

WORKDIR /webapp/drone-ruby