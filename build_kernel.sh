#!/bin/bash
# kernel build script by thehacker911
# edited by mtb3000gt

KERNEL_DIR=$(pwd)
BUILD_USER="$USER"
TOOLCHAIN_DIR=/home/buildserver/aarch64-linux-android-6.0
BUILD_JOB_NUMBER=`grep processor /proc/cpuinfo|wc -l`

# Toolchains

#vars
KERNEL_DEFCONFIG=exynos7420-zerofltespr_defconfig
BASE_VER=`sed -n '2p' mtb3000gt`
DEVICE_VER=`sed -n '4p' mtb3000gt`
VER=`sed -n '6p' mtb3000gt`
MTB3000GT_VER="$BASE_VER$DEVICE_VER$VER"


BUILD_KERNEL()
{	
	echo ""
	echo "=============================================="
	echo "START: MAKE CLEAN"
	echo "=============================================="
	echo ""
	

	make clean
	find . -name "*.dtb" -exec rm {} \;

	echo ""
	echo "=============================================="
	echo "END: MAKE CLEAN"
	echo "=============================================="
	echo ""

	echo ""
	echo "=============================================="
	echo "START: BUILD_KERNEL"
	echo "=============================================="
	echo ""
	echo "$MTB3000GT_VER" 
	
	export LOCALVERSION=-`echo $MTB3000GT_VER`
	export ARCH=arm64
        export SUBARCH=arm64
	export KBUILD_BUILD_USER=mtb3000gt
	export KBUILD_BUILD_HOST=buildserver
        #export USE_CCACHE=1
        export USE_SEC_FIPS_MODE=true
	export CROSS_COMPILE=$BUILD_CROSS_COMPILE
	make ARCH=arm64 $KERNEL_DEFCONFIG
	make ARCH=arm64 -j$BUILD_JOB_NUMBER
	

	echo ""
	echo "================================="
	echo "END: BUILD_KERNEL"
	echo "================================="
	echo ""
}





# MAIN FUNCTION
rm -rf ./build.log
(
	START_TIME=`date +%s`
	BUILD_DATE=`date +%m-%d-%Y`
	BUILD_KERNEL


	END_TIME=`date +%s`
	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Total compile time is $ELAPSED_TIME seconds"
) 2>&1	 | tee -a ./build.log

# Credits:
# Samsung
# google
# osm0sis
# cyanogenmod
# kylon 
