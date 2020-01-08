# see https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/ for Dockerfile best practices

# build me with:
# docker build -t "juicymo/drone-ruby:2.3.3" .

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
    unzip

RUN wget --no-check-certificate https://github.com/kernix/wkhtmltopdf-docker-alpine/raw/master/wkhtmltopdf -P /usr/bin/ && wget ${ALPINE_GLIBC_URL}${GLIBC_PKG} ${ALPINE_GLIBC_URL}${GLIBC_BIN_PKG} && apk add --allow-untrusted ${GLIBC_PKG} ${GLIBC_BIN_PKG}
RUN chmod a+x /usr/bin/wkhtmltopdf

ENV SHELL /bin/bash
ENV LC_ALL en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN gem install bundler --no-ri --no-rdoc -v '< 2'
