#!/bin/sh
HERE=`pwd`
BASE=`basename ${HERE}`
FILESYSTEM_NAME="NOVAsom6Initrd"
output/host/usr/bin/mkimage -A arm -O linux -T ramdisk -C none -n ${FILESYSTEM_NAME} -a 0x80000 -d output/images/rootfs.ext2.gz output/images/uInitrd
cd ../../Deploy
rm ${FILESYSTEM_NAME}
echo ${HERE} ${BASE}
ln -s ../FileSystem/${BASE}/output/images/uInitrd ${FILESYSTEM_NAME}
echo ${BASE} > CurrentFileSystem
