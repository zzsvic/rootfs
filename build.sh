#########################################################################
# File Name     : build.sh
# Author        : zhou.zhaosong
# mail          : zzsvic@163.com
# Created Time  : 2020年09月13日 星期日 18时00分40秒
#########################################################################

#!/bin/bash
# make defconfig
PLATFORM='ARM'
COMPILE='arm-linux-gnueabihf-'

OBJ='/home/zhaosonz/workspace/nfs/rootfs'
LIB='/home/zhaosonz/workspace/nfs/rootfs/lib'
USR_LIB='/home/zhaosonz/workspace/nfs/rootfs/usr/lib'
GCC_LIB='/home/zhaosonz/software/gcc-linaro-arm-linux-gnueabihf/arm-linux-gnueabihf/libc/lib/'
GCC_U_LIB='/home/zhaosonz/software/gcc-linaro-arm-linux-gnueabihf/arm-linux-gnueabihf/libc/usr/lib/'

if [ "$1" = "clean" ];then
	make ARCH=$PLATFORM CROSS_COMPILE=$COMPILE clean
	make ARCH=$PLATFORM CROSS_COMPILE=$COMPILE distclean
	exit 0
elif [ "$1" = "defconfig" ];then
	make ARCH=$PLATFORM CROSS_COMPILE=$COMPILE defconfig
fi


echo "================================================================================"
echo "                                  build busybox                                 "
echo "================================================================================"
if [ ! -d "$OBJ" ];then
	echo "mkdir -p $OBJ"
	mkdir -p $OBJ
fi
make ARCH=$PLATFORM CROSS_COMPILE=$COMPILE 
make ARCH=$PLATFORM CROSS_COMPILE=$COMPILE install CONFIG_PREFIX=$OBJ

echo "================================================================================"
echo "                                   添加lib库                                "
echo "================================================================================"
if [ ! -d "$LIB" ];then
	echo "mkdir -p $LIB"
	mkdir -p $LIB
fi
echo "copy *.so* *.a"

cd $GCC_LIB
cp *.so* *.a $LIB -d
rm $LIB/ld-linux-armhf.so.3
cp ld-linux-armhf.so.3 $LIB -d

cd ~/software/gcc-linaro-arm-linux-gnueabihf/arm-linux-gnueabihf/lib
cp *.so* *.a $LIB/ -d

echo "================================================================================"
echo "                                  添加usr/lib库                                 "
echo "================================================================================"
if [ ! -d "$USR_LIB" ];then
	echo "mkdir -p rootfs/usr/lib"
	CUR_PWD=pwd
    echo "cd $CUR_PWD"
	cd ~/workspace/nfs/rootfs/
	mkdir -p usr/lib
	cd=$CUR_PWD
fi
echo "copy *.so* *.a"
cd $GCC_U_LIB
cp *.so* *.a $USR_LIB/ -d


echo "================================================================================"
echo "                             lib and /usr.lib size                              "
echo "================================================================================"
CUR_PWD=`pwd`

cd $LIB/../
du ./lib ./usr/lib -sh

echo "-------------------------------------------------------------------------------"
echo "cd $CUR_PWD"
cd $CUR_PATH

