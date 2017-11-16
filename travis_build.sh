#!/usr/bin/env bash
echo "LINUX BUILD " ${PLATFORM}

BUILD_DIR=$(pwd)/built/
BUILD_DIR_PLATFORM=${BUILD_DIR}/${PLATFORM} # ./built/ubuntu-xenial
mkdir -p ${BUILD_DIR_PLATFORM}

USER_INFO="$( id -u ${USER} ):$( id -g ${USER} )"
SHARE_USER_INFO="-v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro"
SHARE_BUILD_DIR="-v ${BUILD_DIR_PLATFORM}:/travis"

tar xvf keys.tar
SHARE_SECRETS="-v $(pwd)/private.gpg:/secrets/private.gpg -v $(pwd)/public.gpg:/secrets/public.gpg"

docker stop $(docker ps -aq --filter name=worker-${PLATFORM}) || true
docker rm $(docker ps -aq --filter name=worker-${PLATFORM}) || true
docker build --file Dockerfile.${PLATFORM} -t builder-${PLATFORM} .
docker run --name worker-${PLATFORM} -t -e USER_INFO=${USER_INFO} -e PROTOBUF_VER=${PROTOBUF_VER} -e GRPCIO_VER=${GRPCIO_VER} -e GPGKEY=${GPGKEY} ${SHARE_BUILD_DIR} ${SHARE_SECRETS} ${SHARE_USER_INFO} builder-${PLATFORM} /build.sh

echo "BUILD FINISHED"
echo $(pwd)

ls -lah .

git checkout --orphan ${PLATFORM}
git rm --cached -r .
git add ${BUILD_DIR_PLATFORM}
git commit -m "Protobuf ${PROTOBUF_VER}, gRPC ${GRPCIO_VER}"
git push https://randomshinichi:$GITHUB_TOKEN@github.com/randomshinichi/qrllib-deps-builder.git HEAD:${PLATFORM} -f
