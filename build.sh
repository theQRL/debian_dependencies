#!/usr/bin/env bash

docker stop $(docker ps -aq --filter name=worker) || true
docker rm $(docker ps -aq --filter name=worker) || true

USER_INFO="$( id -u ${USER} ):$( id -g ${USER} )"
SHARE_USER_INFO="-v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -u ${USER_INFO}"
SHARE_SRC="-v $(pwd):/travis"

docker build --file Dockerfile.debian-stretch-deps -t deps-builder .
docker run -d --name worker ${SHARE_SRC} ${SHARE_USER_INFO} deps-builder tail -f /dev/null
docker exec -t -e BUILD_DIR=${BUILD_DIR} -e PROTOBUF_VER=${PROTOBUF_VER} -e GRPCIO_VER=${GRPCIO_VER} worker /build.sh