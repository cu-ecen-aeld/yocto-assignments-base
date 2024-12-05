#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

# Machine is Raspberry Pi 3B+
CONFLINE="MACHINE = \"raspberrypi3\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

# Add the gpio-config recipe to be built in the image
CORE_IM_ADD="CORE_IMAGE_EXTRA_INSTALL += \"gpio-config\""

cat conf/local.conf | grep "${CORE_IM_ADD}" > /dev/null
local_coreimadd_info=$?

#############################################################
# Adds the MACHINE and CORE_IMAGE_EXTRA_INSTALL lines to
# conf/local.conf if it does not exist
#############################################################
if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

if [ $local_coreimadd_info -ne 0 ];then
        echo "Append ${CORE_IM_ADD} in the local.conf file"
        echo ${CORE_IM_ADD} >> conf/local.conf       
else
        echo "${CORE_IM_ADD} already exists in the local.conf file"
fi

# Add the required layers
bitbake-layers show-layers | grep "meta-oe" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-oe layer"
	bitbake-layers add-layer ../meta-openembedded/meta-oe
else
	echo "meta-oe layer already exists"
fi

bitbake-layers show-layers | grep "meta-raspberrypi" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
        echo "Adding meta-raspberrypi layer"
        bitbake-layers add-layer ../meta-raspberrypi
else
        echo "meta-raspberrypi layer already exists"
fi

bitbake-layers show-layers | grep "meta-gpiotest" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-gpiotest layer"
	bitbake-layers add-layer ../meta-gpiotest
else
	echo "meta-gpiotest layer already exists"
fi

set -e
bitbake core-image-base
