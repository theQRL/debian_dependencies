#!/usr/bin/env bash
gpg --import /secrets/public.gpg
gpg --import /secrets/private.gpg
echo "Going to use key ${GPGKEY}"

export BUILD_DIR=/build
echo $PROTOBUF_VER
echo $GRPCIO_VER


export PROTOBUF_DIR=protobuf-$PROTOBUF_VER
export GRPCIO_DIR=grpcio-$GRPCIO_VER
export GRPCIO_TOOLS_DIR=grpcio-tools-$GRPCIO_VER
echo $PROTOBUF_DIR
echo $GRPCIO_DIR
echo $GRPCIO_TOOLS_DIR

#Protobuf

cd $BUILD_DIR
wget https://github.com/google/protobuf/releases/download/v$PROTOBUF_VER/protobuf-python-$PROTOBUF_VER.tar.gz
tar zxvf protobuf-python-$PROTOBUF_VER.tar.gz
# Make protoc first
cd $BUILD_DIR/$PROTOBUF_DIR
./configure && make -j5

# make the sdist of the python bindings module
cd $BUILD_DIR/$PROTOBUF_DIR/python
python3 setup.py --command-packages=stdeb.command sdist_dsc

# stdeb's sdist_dsc makes dist/, deb_dist, and protobuf-$PROTOBUF_VER.tar.gz.
# the source is copied under deb_dist/, but we need it to still think it's in $PROTOBUF_DIR/python for it to compile
cd $BUILD_DIR/$PROTOBUF_DIR/python/deb_dist
ln -s $BUILD_DIR/$PROTOBUF_DIR/src src

cd $BUILD_DIR/$PROTOBUF_DIR/python/deb_dist/$PROTOBUF_DIR
dpkg-buildpackage -k$GPGKEY

# grpcio

cd $BUILD_DIR
pip3 download --no-deps --no-binary :all: grpcio==$GRPCIO_VER grpcio-tools==$GRPCIO_VER
py2dsc --with-python2=False --with-python3=True grpcio-$GRPCIO_VER.tar.gz
cd deb_dist/$GRPCIO_DIR
dpkg-buildpackage -k$GPGKEY

cd $BUILD_DIR
py2dsc --with-python2=False --with-python3=True grpcio-tools-$GRPCIO_VER.tar.gz
cd deb_dist/$GRPCIO_TOOLS_DIR
dpkg-buildpackage -k$GPGKEY

# Move the Protobuf stuff to /build/deb_dist
mv $BUILD_DIR/$PROTOBUF_DIR/python/deb_dist/* $BUILD_DIR/deb_dist

# OK now copy it all to /travis so that Travis's worker can access the files
mkdir -p /travis/${PLATFORM}
find $BUILD_DIR/deb_dist -maxdepth 1 -type f -exec cp {} /travis/${PLATFORM} \;
chown -R $USER_INFO /travis
