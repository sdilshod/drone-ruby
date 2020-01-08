# see https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/ for Dockerfile best practices

# Remind:
# docker build -t "sd/drone-ruby:2.3.3" .
# docker tag sdilshod/drone-ruby:2.3.3

FROM ruby:2.3.3-alpine
MAINTAINER Tomas Jukin <tomas.jukin@juicymo.cz>

ENV BUILD_PACKAGES curl-dev build-base
ENV RUBY_PACKAGES cairo-dev postgresql-dev tzdata wget postgresql-client
ENV WKHTMLTOPDF_PACKAGES gtk+ glib ttf-freefont fontconfig dbus
ENV \
    ALPINE_GLIBC_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/" \
    GLIBC_PKG="glibc-2.21-r2.apk" \
    GLIBC_BIN_PKG="glibc-bin-2.21-r2.apk"

RUN apk add --no-cache \
    $BUILD_PACKAGES \
    $RUBY_PACKAGES \
    $WKHTMLTOPDF_PACKAGES \
    git \
    imagemagick \
    less \
    nodejs \
    openssh \
    pwgen \
    unzip \
    zip \
    ca-certificates

RUN wget --no-check-certificate https://github.com/kernix/wkhtmltopdf-docker-alpine/raw/master/wkhtmltopdf -P /usr/bin/ \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk \
    apk add glibc-2.30-r0.apk

RUN chmod a+x /usr/bin/wkhtmltopdf

ENV SHELL /bin/bash
ENV LC_ALL en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN gem install bundler --no-ri --no-rdoc -v '< 2'
