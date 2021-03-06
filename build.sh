#!/usr/bin/env bash
set -e
use_sudo=0
image=
pg_version="$(cat pg_version)"

while [[ "$1" != "" ]]; do
    case $1 in
        -s | --sudo )           use_sudo=1
                                ;;
        -pg | --pg-version )    shift
                                pg_version=$1
                                ;;
        -i | --image )          shift
                                image=$1
                                ;;
    esac
    shift
done

if [[ ${use_sudo} == 1 ]]
 then
        sudo_string="sudo "
        else
        sudo_string=""
fi

${sudo_string} docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}

build_version (){
    image_version=$1
    pg_version=$2
    sudo_string=$3
    general="$(echo ${image_version} | cut -d '|' -f1 -s)"
    image_version="$(echo ${image_version} | cut -d '|' -f2)"
    ruby_version="$(echo ${image_version} | cut -d '-' -f1)"

    sed -e "s/%%FROM%%/$image_version/g" \
        -e "s/%%TAG%%/$ruby_version/g" \
        -e "s/%%POSTGRES%%/$pg_version/g" \
     Dockerfile.template > Dockerfile

     ${sudo_string} docker build .
     ${sudo_string} docker build -t juicymo/drone-ruby:${ruby_version} .
     ${sudo_string} docker push juicymo/drone-ruby:${ruby_version}

    if [[ ${general} == "g" ]]
    then
        minor_version="$(echo ${ruby_version} | cut -d '.' -f1-2)"
        ${sudo_string} docker build -t juicymo/drone-ruby:${minor_version} .
        ${sudo_string} docker push juicymo/drone-ruby:${minor_version}
    fi
}

if [[ ${image} == "" ]] ; then
    while read -r line
     do
        build_version ${line} ${pg_version} ${sudo_string}
    done < versions

    else

    build_version ${image} ${pg_version} ${sudo_string}
fi

