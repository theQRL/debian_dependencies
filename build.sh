#!/usr/bin/env bash

docker stop $(docker ps -aq --filter name=worker) || true
docker rm $(docker ps -aq --filter name=worker) || true

docker build --file Dockerfile.debian-stretch-deps -t deps-builder .
docker run -d --name worker -v $(pwd):/travis deps-builder tail -f /dev/null
docker exec -t -e BUILD_DIR=${BUILD_DIR} -e PROTOBUF_VER=${PROTOBUF_VER} -e GRPCIO_VER=${GRPCIO_VER} worker /build.sh