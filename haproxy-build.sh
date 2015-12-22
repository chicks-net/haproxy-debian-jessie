#!/bin/bash

# define variables
ITERATION=2
DIRGIT=/home/chicks/Documents/git/haproxy-debian-jessie
DIRBUILD=/home/chicks/Documents/build-haproxy
DIRBUILT=/home/chicks/Documents/built-haproxy
HAPROXY_VER=1.6.2
SRC=$DIRGIT/src/haproxy_${HAPROXY_VER}.orig.tar.gz

# empty dirs and mkdir
rm -rf $DIRBUILD $DIRBUILT
mkdir -p $DIRBUILD || exit 1
mkdir -p $DIRBUILT || exit 1

#ls -ld $DIRBUILD $DIRBUILT
#ls -ld $SRC

# the build itself
cd $DIRBUILD
tar xfz $SRC
cd haproxy-1.6.2
make TARGET=linux2628 CPU=x86_64 USE_OPENSSL=1 USE_ZLIB=1 DESTDIR=$DIRBUILT PREFIX=/usr
make DESTDIR=$DIRBUILT PREFIX=/usr install

# package
cd $DIRGIT
OUTDEB=haproxy_${HAPROXY_VER}-${ITERATION}_amd64.deb
rm $OUTDEB
echo ""
fpm -s dir -t deb -n haproxy -v $HAPROXY_VER --iteration $ITERATION -C $DIRBUILT usr
echo ""
dpkg -c $OUTDEB
echo ""
git add $OUTDEB
