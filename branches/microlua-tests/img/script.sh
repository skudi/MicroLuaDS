#!/bin/bash
# Create a FAT16 image (by Ludo6431)

cd "`dirname $0`"

BASESRC="fsroot"
IMGFILE="fsimg.img"
IMGSIZE="16"   # in MB
TMPDIR="`mktemp -d`"

if [ $1 ]
then
    IMGFILE=$1
fi

if [ $2 ]
then
    BASESRC=$2
fi

# colors :
# 31 : removing
# 32 : copying
# 33 : cleaning
# 34 : creating archive

# <-- verifying mandatory things
    if [ ! -d ${BASESRC} ]
    then
        echo "Can't find the input directory : ${BASESRC}"
        exit 1
    fi
# -->

# <- create a new blank FAT partition
    echo "Creating ${IMGSIZE}MB FAT16 image..."
    dd if=/dev/zero of=${IMGFILE} bs=1048576 count=${IMGSIZE}
    mkdosfs -F16 ${IMGFILE}
    echo "OK"
# -->

# <-- mount it
    echo -n "Mounting image..."
    sudo mount -o loop -o uid=1000 ${IMGFILE} ${TMPDIR}
    echo "OK"
# -->

# <-- copy files in it
    echo -n "Copying files..."
    cp -R ${BASESRC}/* ${TMPDIR}/
    echo "OK"
# -->

# <-- unmount it
    echo -n "Unmounting image..."
    sudo umount ${TMPDIR}
    rmdir ${TMPDIR}
    echo "OK"
# -->
