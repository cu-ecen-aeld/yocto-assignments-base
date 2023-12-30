#!/bin/bash
# 
# 
git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

CONFLINE="MACHINE = \"raspberrypi4\""

#Licence
LICENCE="LICENSE_FLAGS_WHITELIST = \"commercial\""

#Create image for SD
IMAGE="IMAGE_FSTYPES = \"wic.bz2\""

#Set GPU memory as minimum
MEMORY="GPU_MEM = \"16\""


#Add any packages needed 
ADD_PACK="CORE_IMAGE_EXTRA_INSTALL += \"gui\""


#Add wifi support
DISTRO_F="DISTRO_FEATURES:append = \"wifi\""


# Add packages required for QT5 application see wiki for details    
IMAGE_ADD="IMAGE_INSTALL:append =  \"qtbase \
    qtbase-dev \
    qtbase-mkspecs \
    qtbase-plugins \
    qtbase-tools \
    qt3d \
    qt3d-dev \
    qt3d-mkspecs \
    qtcharts \
    qtcharts-dev \
    qtcharts-mkspecs \
    qtconnectivity-dev \
    qtconnectivity-mkspecs \
    qtquickcontrols2 \
    qtquickcontrols2-dev \
    qtquickcontrols2-mkspecs \
    qtdeclarative \
    qtdeclarative-dev \
    qtdeclarative-mkspecs \
    qtgraphicaleffects \
    qtgraphicaleffects-dev \
    linux-firmware-bcm43430 \
    bluez5 \
    i2c-tools \
    bridge-utils \
    hostapd \
    iptables \
    wpa-supplicant \""


IMAGE_F="IMAGE_FEATURES += \"ssh-server-openssh tools-sdk tools-debug\""


cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

cat conf/local.conf | grep "${IMAGE}" > /dev/null
local_image_info=$?

cat conf/local.conf | grep "${MEMORY}" > /dev/null
local_memory_info=$?

cat conf/local.conf | grep "${ADD_PACK}" > /dev/null
local_pack_info=$?

cat conf/local.conf | grep "${DISTRO_F}" > /dev/null
local_distro_info=$?

cat conf/local.conf | grep "${IMAGE_ADD}" > /dev/null
local_imgadd_info=$?

cat conf/local.conf | grep "${LICENCE}" > /dev/null
local_licn_info=$?

cat conf/local.conf | grep "${IMAGE_F}" > /dev/null
local_imgf_info=$?



if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi


if [ $local_image_info -ne 0 ];then 
    echo "Append ${IMAGE} in the local.conf file"
	echo ${IMAGE} >> conf/local.conf
else
	echo "${IMAGE} already exists in the local.conf file"
fi


if [ $local_memory_info -ne 0 ];then
    echo "Append ${MEMORY} in the local.conf file"
	echo ${MEMORY} >> conf/local.conf
else
	echo "${MEMORY} already exists in the local.conf file"
fi


if [ $local_pack_info -ne 0 ];then
    echo "Append ${ADD_PACK} in the local.conf file"
	echo ${ADD_PACK} >> conf/local.conf
else
	echo "${ADD_PACK} already exists in the local.conf file"
fi


if [ $local_distro_info -ne 0 ];then
    echo "Append ${DISTRO_F} in the local.conf file"
	echo ${DISTRO_F} >> conf/local.conf
else
	echo "${DISTRO_F} already exists in the local.conf file"
fi


if [ $local_imgadd_info -ne 0 ];then
    echo "Append ${IMAGE_ADD} in the local.conf file"
	echo ${IMAGE_ADD} >> conf/local.conf
else
	echo "${IMAGE_ADD} already exists in the local.conf file"
fi


if [ $local_licn_info -ne 0 ];then
    echo "Append ${LICENCE} in the local.conf file"
	echo ${LICENCE} >> conf/local.conf
else
	echo "${LICENCE} already exists in the local.conf file"
fi


if [ $local_imgf_info -ne 0 ];then
    echo "Append ${IMAGE_F} in the local.conf file"
	echo ${IMAGE_F} >> conf/local.conf
else
	echo "${IMAGE_F} already exists in the local.conf file"
fi



bitbake-layers show-layers | grep "meta-qt5" > /dev/null
layer_info=$?


if [ $layer_info -ne 0 ];then
	echo "Adding meta-qt5 layer"
	bitbake-layers add-layer ../meta-qt5
else
	echo "layer meta-qt5 already exists"
fi


bitbake-layers show-layers | grep "meta-raspberrypi" > /dev/null
layer_info=$?


if [ $layer_info -ne 0 ];then
	echo "Adding meta-raspberrypi layer"
	bitbake-layers add-layer ../meta-raspberrypi
else
	echo "layer meta-raspberrypi already exists"
fi


bitbake-layers show-layers | grep "meta-oe" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
    echo "Adding meta-oe layer"
	bitbake-layers add-layer ../meta-openembedded/meta-oe
else
	echo "layer meta-oe already exists"
fi

bitbake-layers show-layers | grep "meta-python" > /dev/null
layer_info=$?


if [ $layer_info -ne 0 ];then
    echo "Adding meta-python layer"
	bitbake-layers add-layer ../meta-openembedded/meta-python
else
	echo "layer meta-python already exists"
fi



bitbake-layers show-layers | grep "meta-networking" > /dev/null
layer_info=$?


if [ $layer_info -ne 0 ];then
    echo "Adding meta-networking layer"
	bitbake-layers add-layer ../meta-openembedded/meta-networking
else
	echo "layer meta-networking already exists"
fi


bitbake-layers show-layers | grep "meta-multimedia" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-multimedia layer"
	bitbake-layers add-layer ../meta-openembedded/meta-multimedia
else
	echo "layer meta-multimedia already exists"
fi


bitbake-layers show-layers | grep "meta-gui" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-gui layer"
	bitbake-layers add-layer ../meta-gui
else
	echo "meta-gui layer already exists"
fi



set -e
bitbake core-image-sato
