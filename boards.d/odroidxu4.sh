#!/usr/bin/bash
DISKIMAGE=$1
STAGE1LOADER=$2
UBOOT=$3
ROOTPATH=$4
ROOTFILES=$5
ROOTPARTINDEX=$6
ROOTUUID=$7

#Enter Custom Commands Below
echo "Writing U-Boot Image"

dd if=files/odroidxu4/bl1.bin of=$DISKIMAGE seek=1
dd if=files/odroidxu4/bl2.bin of=$DISKIMAGE seek=31
dd if=files/odroidxu4/u-boot.bin of=$DISKIMAGE seek=63
dd if=files/odroidxu4/tzsw.bin of=$DISKIMAGE seek=1503
cp $ROOTFILES $ROOTPATH/boot/
sed -i 's/UUID/UUID='$ROOTUUID'/' $ROOTPATH/boot/boot.ini

echo "set autorelabel"
touch $ROOTPATH/.autorelabel

echo "remove rbf repos"
rm $ROOTPATH/etc/yum.repos.d/*_rbf.repo

echo "remove yum cache"
rm -rf $ROOTPATH/var/cache/yum/*

echo "zero the disks freespace"
dd if=/dev/zero of=$ROOTPATH/zero
dd if=/dev/zero of=$ROOTPATH/boot/zero
sync
rm -f $ROOTPATH/zero $ROOTPATH/boot/zero

echo "fix ppp install issue"
mkdir -p $ROOTPATH/run/lock/ppp

exit 0
