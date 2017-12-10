#!/usr/bin/bash
DISKIMAGE=$1
STAGE1LOADER=$2
UBOOT=$3
ROOTPATH=$4
ROOTFILES=$5
ROOTPARTINDEX=$6
ROOTUUID=$7

echo "remove rbf repos"
rm $ROOTPATH/etc/yum.repos.d/*_rbf.repo

echo "remove yum cache"
rm -rf $ROOTPATH/var/cache/yum/*

echo "zero the disks freespace"
dd if=/dev/zero of=$ROOTPATH/zero
sync
rm -f $ROOTPATH/zero $ROOTPATH/boot/zero

echo "fix ppp install issue"
mkdir -p $ROOTPATH/run/lock/ppp

exit 0
