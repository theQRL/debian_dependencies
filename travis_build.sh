#!/usr/bin/env bash
echo "LINUX BUILD " ${PLATFORM}

USER_INFO="$( id -u ${USER} ):$( id -g ${USER} )"
SHARE_USER_INFO="-v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro"
SHARE_SRC="-v $(pwd):/travis"

docker stop $(docker ps -aq --filter name=worker-${PLATFORM}) || true
docker rm $(docker ps -aq --filter name=worker-${PLATFORM}) || true
docker build --file Dockerfile.${PLATFORM} -t builder-${PLATFORM} .
docker run --name worker-${PLATFORM} -t -e USER_INFO=${USER_INFO} -e PROTOBUF_VER=${PROTOBUF_VER} -e GRPCIO_VER=${GRPCIO_VER} ${SHARE_SRC} ${SHARE_USER_INFO} builder-${PLATFORM} /build.sh
