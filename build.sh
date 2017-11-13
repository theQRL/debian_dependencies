#!/usr/bin/env bash

docker stop $(docker ps -aq --filter name=worker) || true
docker rm $(docker ps -aq --filter name=worker) || true

USER_INFO="$( id -u ${USER} ):$( id -g ${USER} )"
SHARE_USER_INFO="-v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro"
SHARE_SRC="-v $(pwd):/travis"

docker build --file Dockerfile.debian-stretch-deps -t stretch-deps .
docker build --file Dockerfile.ubuntu-xenial-deps -t xenial-deps .

docker run -t -e USER_INFO=${USER_INFO} -e PROTOBUF_VER=${PROTOBUF_VER} -e GRPCIO_VER=${GRPCIO_VER} ${SHARE_SRC} ${SHARE_USER_INFO} stretch-deps /build.sh
docker run -t -e USER_INFO=${USER_INFO} -e PROTOBUF_VER=${PROTOBUF_VER} -e GRPCIO_VER=${GRPCIO_VER} ${SHARE_SRC} ${SHARE_USER_INFO} xenial-deps /build.sh