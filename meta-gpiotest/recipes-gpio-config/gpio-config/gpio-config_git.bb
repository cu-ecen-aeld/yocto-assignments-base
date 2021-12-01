# See http://git.yoctoproject.org/cgit.cgi/poky/tree/meta/files/common-licenses
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://git@github.com/cu-ecen-aeld/final-project-DhruvHMehta.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"

# This commit is tested to work
SRCREV = "afbb4cf7e025920c27f2abda57a044afdef3803d"

# Source Directory is the root of the git repo
S = "${WORKDIR}/git"
# Build Directory is where the Makefile and source files live
B = "${S}/gpio"

FILES_${PN} += "${bindir}/gpioreadtest"
FILES_${PN} += "${bindir}/gpiowritetest"

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
	install -m 0755 ${B}/gpioreadtest ${D}${bindir}/
	install -m 0755 ${B}/gpiowritetest ${D}${bindir}/
}
