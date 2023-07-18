# See http://git.yoctoproject.org/cgit.cgi/poky/tree/meta/files/common-licenses
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Location of files in the current directory
SRC_URI = "file://gpio_read.c \
	   file://gpio_write.c \
	   file://Makefile"

# Source Directory is the root of the git repo
S = "${WORKDIR}/"

FILES_${PN} += "${bindir}/gpioreadtest"
FILES_${PN} += "${bindir}/gpiowritetest"

# Build-time dependency
DEPENDS = "libgpiod"
TARGET_LDFLAGS += "-lgpiod"

do_configure () {
	:
}

do_compile () {
	oe_runmake
}

do_install () {
	#Install your binaries/scripts here.
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/gpioreadtest ${D}${bindir}/
	install -m 0755 ${WORKDIR}/gpiowritetest ${D}${bindir}/
}
