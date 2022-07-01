SUMMARY = "openeuler toolkit"
HOMEPAGE = "https://gitee.com/openeuler/yocto-embedded-tools"
DESCRIPTION = "some scripting tools"
SECTION = "base"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://merge_config.sh;beginline=1;endline=14;md5=2c72118706aebe2f99c74427710957bf"

SRC_URI = "file://kernel-5.10/scripts/kconfig/merge_config.sh"

S = "${WORKDIR}/kernel-5.10/scripts/kconfig"

# used as the native tool only
inherit native

do_compile() {
:
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/merge_config.sh ${D}${bindir}
}
