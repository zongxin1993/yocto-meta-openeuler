# main bbfile: meta-networking/recipes-support/ntp/ntp_4.2.8p15.bb

# version in openEuler
PV = "4.2.8p15"

# files, patches can't be applied in openeuler or conflict with openeuler
SRC_URI_remove = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-${PV}.tar.gz \
           file://ntp-4.2.4_p6-nano.patch \
           file://reproducibility-fixed-path-to-posix-shell.patch \
           file://0001-libntp-Do-not-use-PTHREAD_STACK_MIN-on-glibc.patch \
           file://0001-test-Fix-build-with-new-compiler-defaults-to-fno-com.patch \
           file://0001-sntp-Fix-types-in-check-for-pthread_detach.patch \
"

# files, patches that come from openeuler
SRC_URI += "file://ntp-${PV}.tar.gz;name=tarball \
           file://Do-not-use-PTHREAD_STACK_MIN-on-glibc.patch \
           file://bugfix-fix-bind-port-in-debug-mode.patch \
           file://fix-MD5-manpage.patch \
           file://fix-multiple-defination-with-gcc-10.patch \
           file://ntp-ssl-libs.patch \
	   file://ntpd \
           file://ntp.conf \
           file://ntpdate \
           file://ntpdate.default \
           file://ntpdate.service \
           file://ntpd.service \
           file://sntp.service \
           file://sntp \
           file://ntpd.list \
"


SRC_URI[tarball.md5sum] = "e1e6b23d2fc75cced41801dbcd6c2561"
SRC_URI[tarball.sha256sum] = "f65840deab68614d5d7ceb2d0bb9304ff70dcdedd09abb79754a87536b849c19"

#S = "${WORKDIR}/${BP}"

