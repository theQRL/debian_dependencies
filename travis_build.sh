#!/usr/bin/env bash
echo "LINUX BUILD " ${PLATFORM}

BUILD_DIR=$(pwd)/built/

USER_INFO="$( id -u ${USER} ):$( id -g ${USER} )"
SHARE_USER_INFO="-v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro"
SHARE_BUILD_DIR="-v ${BUILD_DIR}:/travis"

# In qrllib, the Docker container untars and imports the keys from the travis dir.
# However, qrllib-deps-builder is different in that the container doesn't get to see the contents of this dir.
# That's because it gets the source from elsewhere, and simply places the compiled debs in built/.
# so we handle the keys here, and make them explicitly available through mountpoints.
tar xvf keys.tar
SHARE_SECRETS="-v $(pwd)/private.gpg:/secrets/private.gpg -v $(pwd)/public.gpg:/secrets/public.gpg"

docker stop -t 0 $(docker ps -aq --filter name=worker-${PLATFORM}) || true
docker rm $(docker ps -aq --filter name=worker-${PLATFORM}) || true
docker build --file Dockerfile.${PLATFORM} -t builder-${PLATFORM} .
#docker run --name worker-${PLATFORM} -it -e USER_INFO=${USER_INFO} -e PLATFORM=${PLATFORM} --env-file=env ${SHARE_BUILD_DIR} ${SHARE_SECRETS} ${SHARE_USER_INFO} builder-${PLATFORM} bash
docker run --name worker-${PLATFORM} -t -e USER_INFO=${USER_INFO} -e PLATFORM=${PLATFORM} --env-file=env ${SHARE_BUILD_DIR} ${SHARE_SECRETS} ${SHARE_USER_INFO} builder-${PLATFORM} /build.sh

echo "BUILD FINISHED"

