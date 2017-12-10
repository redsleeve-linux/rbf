#!/usr/bin/bash
DISKIMAGE=$1
STAGE1LOADER=$2
UBOOT=$3
ROOTPATH=$4
ROOTFILES=$5
ROOTPARTINDEX=$6
ROOTUUID=$7

#Enter Custom Commands Below
echo "Writing Boot Section of disk (inc new partition table)"

sgdisk -g $DISKIMAGE

sgdisk -r 1:6 $DISKIMAGE
sgdisk -r 2:7 $DISKIMAGE
sgdisk -a 64 -n 1:64:8063 $DISKIMAGE
sgdisk -a 64 -n 2:8064:8191 $DISKIMAGE
sgdisk -a 2048 -n 3:4M:+4M $DISKIMAGE
sgdisk -n 4:8M:+4M $DISKIMAGE
sgdisk -n 5:12M:+4M $DISKIMAGE

sgdisk -c 1:loader1 $DISKIMAGE
sgdisk -c 2:reserved1 $DISKIMAGE
sgdisk -c 3:reserved2 $DISKIMAGE
sgdisk -c 4:loader2 $DISKIMAGE
sgdisk -c 5:atf $DISKIMAGE
sgdisk -c 6:boot $DISKIMAGE
sgdisk -c 7:root $DISKIMAGE

sgdisk -A 6:set:2:1 $DISKIMAGE

xzcat files/rock64/loader1.xz |dd of=$DISKIMAGE obs=512 seek=64
xzcat files/rock64/loader2.xz |dd of=$DISKIMAGE obs=512 seek=16384
xzcat files/rock64/atf.xz |dd of=$DISKIMAGE obs=512 seek=24576

mkdir $ROOTPATH/boot/extlinux
cp $ROOTFILES $ROOTPATH/boot/extlinux
sed -i 's/UUID/UUID='$ROOTUUID'/' $ROOTPATH/boot/extlinux/extlinux.conf

echo "armv5tel-redhat-linux-gnu" > $ROOTPATH/etc/rpm/platform

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

echo "TODO fix GPT"

exit 0
