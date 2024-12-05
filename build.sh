#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.
# Modified by Rishab Shah

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

###############################################################
# Select the appropriate machine
# Machine is Raspberry Pi 3B+ used for the project - Fall 2021
###############################################################
CONFLINE="MACHINE = \"raspberrypi3\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

###############################################################
# Add the following lines to enable I2C support and load the 
# I2C module at boot
###############################################################
# Add I2C support
MODULE_I2C="ENABLE_I2C = \"1\""
cat conf/local.conf | grep "${MODULE_I2C}" > /dev/null
local_i2c_info=$?

# Autoload I2C_MODULE
AUTOLOAD_I2C="KERNEL_MODULE_AUTOLOAD:rpi += \"i2c-dev i2c-bcm2708\""
cat conf/local.conf | grep "${AUTOLOAD_I2C}" > /dev/null
local_i2c_autoload_info=$?

###############################################################
# Add the following to add i2c-tools support for detecting 
# I2C device
###############################################################
IMAGE_ADD="IMAGE_INSTALL_append = \"i2c-tools\""
cat conf/local.conf | grep "${IMAGE_ADD}" > /dev/null
local_imgadd_info=$?
##############################################################
# Adds the MACHINE,ENABLE_I2C,KERNEL_MODULE_AUTLOAD:rpi,
# IMAGE_INSTALL_append in the conf/local.conf if it does not exist
##############################################################
if [ $local_conf_info -ne 0 ];then
        echo "Append ${CONFLINE} in the local.conf file"
        echo ${CONFLINE} >> conf/local.conf

else
        echo "${CONFLINE} already exists in the local.conf file"
fi

##############################################################
# Add the following in local.conf to enable the I2C and
# autoload the module at boot
##############################################################
if [ $local_i2c_info -ne 0 ];then
        echo "Append ${MODULE_I2C} in the local.conf file"
        echo ${MODULE_I2C} >> conf/local.conf
else
        echo "${MODULE_I2C} already exists in the local.conf file"
fi

if [ $local_i2c_autoload_info -ne 0 ];then
        echo "Append ${AUTOLOAD_I2C} in the local.conf file"
        echo ${AUTOLOAD_I2C} >> conf/local.conf
else
        echo "${AUTOLOAD_I2C} already exists in the local.conf file"
fi

##############################################################
# Add the following in local.conf to enable the i2c-tools support
# to analyze the i2c devices connected to the r-pi
##############################################################
if [ $local_imgadd_info -ne 0 ];then
        echo "Append ${IMAGE_ADD} in the local.conf file"
        echo ${IMAGE_ADD} >> conf/local.conf
else
        echo "${IMAGE_ADD} already exists in the local.conf file"
fi
#############################################################
# Add the required layers to boot the r-pi with basic support
# Baking the layers as per update in the local.conf file based upon if the
# meta-layers are present or not already
#############################################################
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

############################################################
# Start baking the image
############################################################
set -e
bitbake core-image-base
                              
