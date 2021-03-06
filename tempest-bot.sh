#!/bin/bash
#
# Copyright © 2021, Tashfin Shakeer Rhythm <tashfinshakeerrhythm@gmail.com>
#
# USage: . tempest-bot.sh device version
#

echo "*  Tempest Kernel Buildbot"

LC_ALL=C date +%Y-%m-%d
date=`date +"%Y%m%d-%H%M"`
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
HOME=/home/tashar
REPACK_DIR=$HOME/AnyKernel3
OUT=$KERNEL_DIR/out
DEVICE_NAME=a26x-new

rm -rf out
mkdir -p out
make O=out clean
make O=out mrproper
make O=out ARCH=arm64 ${DEVICE_NAME}_defconfig
PATH="$HOME/toolchains/proton-clang/bin:${PATH}" \
make -j$(nproc --all) O=out \
ARCH=arm64 \
CC="ccache $HOME/toolchains/proton-clang/bin/clang" \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi-

cd $REPACK_DIR
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/
FINAL_ZIP="Tempest-v1.0-EAS-${DEVICE_NAME}-${date}.zip"
zip -r9 "${FINAL_ZIP}" *
cp *.zip $OUT
rm *.zip
cd $KERNEL_DIR
rm AnyKernel3/Image.gz-dtb

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo -e "Done"
