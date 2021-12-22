require glibc.inc
require glibc-version.inc

CVE_CHECK_WHITELIST += "CVE-2020-10029 CVE-2021-27645"

# glibc https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2019-1010022
# glibc https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2019-1010023
# glibc https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2019-1010024
# Upstream glibc maintainers dispute there is any issue and have no plans to address it further.
# "this is being treated as a non-security bug and no real threat."
CVE_CHECK_WHITELIST += "CVE-2019-1010022 CVE-2019-1010023 CVE-2019-1010024"

# glibc https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2019-1010025
# Allows for ASLR bypass so can bypass some hardening, not an exploit in itself, may allow
# easier access for another. "ASLR bypass itself is not a vulnerability."
# Potential patch at https://sourceware.org/bugzilla/show_bug.cgi?id=22853
CVE_CHECK_WHITELIST += "CVE-2019-1010025"

DEPENDS += "gperf-native bison-native make-native"

NATIVESDKFIXES ?= ""
NATIVESDKFIXES_class-nativesdk = "\
           file://0003-nativesdk-glibc-Look-for-host-system-ld.so.cache-as-.patch \
           file://0004-nativesdk-glibc-Fix-buffer-overrun-with-a-relocated-.patch \
           file://0005-nativesdk-glibc-Raise-the-size-of-arrays-containing-.patch \
           file://0006-nativesdk-glibc-Allow-64-bit-atomics-for-x86.patch \
           file://0007-nativesdk-glibc-Make-relocatable-install-for-locales.patch \
           file://0008-nativesdk-glibc-Fall-back-to-faccessat-on-faccess2-r.patch \
"
SRC_URI =  "file://glibc/glibc-${PV}.tar.xz \
	   file://glibc/0001-add-base-files-for-libphtread-condition-family.patch \
	   file://glibc/0002-add-header-files-for-libphtread_2_17_so.patch \
	   file://glibc/0003-add-build-script-and-files-of-libpthread_2_17_so.patch \
	   file://glibc/0004-add-two-header-files-with-some-deleted-macros.patch \
	   file://glibc/0005-add-pthread-functions_h.patch \
	   file://glibc/0006-add-elsion-function-which-moved-to-libc-in-glibc-2.34.patch \
	   file://glibc/0007-add-lowlevellock_2_17_c.patch \
	   file://glibc/0008-add-pause_nocancel_2_17.patch \
	   file://glibc/0009-add-unwind-with-longjmp.patch \
	   file://glibc/1-5-AArch64-Improve-A64FX-memset-for-small-sizes.patch \
	   file://glibc/2-5-AArch64-Improve-A64FX-memset-for-large-sizes.patch \
	   file://glibc/3-5-AArch64-Improve-A64FX-memset-for-remaining-bytes.patch \
	   file://glibc/4-5-AArch64-Improve-A64FX-memset-by-removing-unroll3.patch \
	   file://glibc/5-5-AArch64-Improve-A64FX-memset-medium-loops.patch \
	   file://glibc/aarch64-Make-elf_machine_-load_address-dynamic-robus.patch \
	   file://glibc/AArch64-Update-A64FX-memset-not-to-degrade-at-16KB.patch \
	   file://glibc/arm-Simplify-elf_machine_-load_address-dynamic.patch \
	   file://glibc/Avoid-warning-overriding-recipe-for-.-tst-ro-dynamic.patch \
	   file://glibc/backport-CVE-2021-38604-0001-librt-add-test-bug-28213.patch \
	   file://glibc/backport-CVE-2021-38604-0002-librt-fix-NULL-pointer-dereference-bug-28213.patch \
	   file://glibc/copy_and_spawn_sgid-Avoid-double-calls-to-close.patch \
	   file://glibc/delete-no-hard-link-to-avoid-all_language-package-to.patch \
	   file://glibc/elf-Avoid-deadlock-between-pthread_create-and-ctors-.patch \
	   file://glibc/elf-Drop-elf-tls-macros.h-in-favor-of-__thread-and-t.patch \
	   file://glibc/elf-Fix-missing-colon-in-LD_SHOW_AUXV-output-BZ-2825.patch \
	   file://glibc/elf-Unconditionally-use-__ehdr_start.patch \
	   file://glibc/gaiconf_init-Avoid-double-free-in-label-and-preceden.patch \
	   file://glibc/gconv-Do-not-emit-spurious-NUL-character-in-ISO-2022.patch \
	   file://glibc/gconv_parseconfdir-Fix-memory-leak.patch \
	   file://glibc/gethosts-Remove-unused-argument-_type.patch \
	   file://glibc/glibc-1070416.patch \
	   file://glibc/glibc-c-utf8-locale.patch \
	   file://glibc/iconv_charmap-Close-output-file-when-done.patch \
	   file://glibc/iconvconfig-Fix-behaviour-with-prefix-BZ-28199.patch \
	   file://glibc/ldconfig-avoid-leak-on-empty-paths-in-config-file.patch \
	   file://glibc/Linux-Fix-fcntl-ioctl-prctl-redirects-for-_TIME_BITS.patch \
	   file://glibc/linux-Simplify-get_nprocs.patch \
	   file://glibc/Linux-Simplify-__opensock-and-fix-race-condition-BZ-.patch \
	   file://glibc/misc-Add-__get_nprocs_sched.patch \
	   file://glibc/mtrace-Fix-output-with-PIE-and-ASLR-BZ-22716.patch \
	   file://glibc/mtrace-Use-a-static-buffer-for-printing-BZ-25947.patch \
	   file://glibc/nis-Fix-leak-on-realloc-failure-in-nis_getnames-BZ-2.patch \
	   file://glibc/posix-Fix-attribute-access-mode-on-getcwd-BZ-27476.patch \
	   file://glibc/pthread-tst-cancel28-Fix-barrier-re-init-race-condit.patch \
	   file://glibc/Remove-sysdeps-tls-macros.h.patch \
	   file://glibc/linux-Revert-the-use-of-sched_getaffinity-on-get_npr.patch \
	   file://glibc/riscv-Drop-reliance-on-_GLOBAL_OFFSET_TABLE_-0.patch \
	   file://glibc/rtld-copy-terminating-null-in-tunables_strdup-bug-28.patch \
	   file://glibc/rt-Set-the-correct-message-queue-for-tst-mqueue10.patch \
	   file://glibc/support-Add-support_wait_for_thread_exit.patch \
	   file://glibc/time-Fix-overflow-itimer-tests-on-32-bit-systems.patch \
	   file://glibc/turn-default-value-of-x86_rep_stosb_threshold_form_2K_to_1M.patch \
	   file://glibc/Update-string-test-memmove.c-to-cover-16KB-copy.patch \
	   file://glibc/Use-__executable_start-as-the-lowest-address-for-pro.patch \
	   file://glibc/x86-64-Optimize-load-of-all-bits-set-into-ZMM-regist.patch \
	   file://glibc/x86_64-Simplify-elf_machine_-load_address-dynamic.patch \ 
	   file://glibc/x86-64-Use-testl-to-check-__x86_string_control.patch \ 
	   file://glibc/nptl-pthread_kill-pthread_cancel-should-not-fail-aft.patch \
	   file://glibc/nptl-Fix-race-between-pthread_kill-and-thread-exit-b.patch \
	   file://glibc/nptl-pthread_kill-needs-to-return-ESRCH-for-old-prog.patch \
	   file://glibc/nptl-Fix-type-of-pthread_mutexattr_getrobust_np-pthr.patch \
	   file://glibc/nptl-Avoid-setxid-deadlock-with-blocked-signals-in-t.patch \
	   file://glibc/nptl-pthread_kill-must-send-signals-to-a-specific-th.patch \
	   file://glibc/ld.so-Replace-DL_RO_DYN_SECTION-with-dl_relocate_ld-.patch \
	   file://glibc/ld.so-Initialize-bootstrap_map.l_ld_readonly-BZ-2834.patch\
	   file://glibc/x86-fix-Autoconf-caching-of-instruction-support-chec.patch \
           file://etc/ld.so.conf \
           file://generate-supported.mk \
           file://makedbs.sh \
           \
           ${NATIVESDKFIXES} \
           file://0009-fsl-e500-e5500-e6500-603e-fsqrt-implementation.patch \
           file://0010-ppc-sqrt-Fix-undefined-reference-to-__sqrt_finite.patch \
           file://0011-__ieee754_sqrt-f-are-now-inline-functions-and-call-o.patch \
           file://0012-Quote-from-bug-1443-which-explains-what-the-patch-do.patch \
           file://0013-eglibc-run-libm-err-tab.pl-with-specific-dirs-in-S.patch \
           file://0014-__ieee754_sqrt-f-are-now-inline-functions-and-call-o.patch \
           file://0015-sysdeps-gnu-configure.ac-handle-correctly-libc_cv_ro.patch \
           file://0016-yes-within-the-path-sets-wrong-config-variables.patch \
           file://0017-timezone-re-written-tzselect-as-posix-sh.patch \
           file://0018-Remove-bash-dependency-for-nscd-init-script.patch \
           file://0019-eglibc-Cross-building-and-testing-instructions.patch \
           file://0020-eglibc-Help-bootstrap-cross-toolchain.patch \
           file://0021-eglibc-Resolve-__fpscr_values-on-SH4.patch \
           file://0022-eglibc-Forward-port-cross-locale-generation-support.patch \
           file://0024-localedef-add-to-archive-uses-a-hard-coded-locale-pa.patch \
           file://0025-elf-dl-deps.c-Make-_dl_build_local_scope-breadth-fir.patch \
           file://0026-intl-Emit-no-lines-in-bison-generated-files.patch \
           file://0027-locale-prevent-maybe-uninitialized-errors-with-Os-BZ.patch \
           file://0028-readlib-Add-OECORE_KNOWN_INTERPRETER_NAMES-to-known-.patch \
           file://0029-wordsize.h-Unify-the-header-between-arm-and-aarch64.patch \
           file://0030-powerpc-Do-not-ask-compiler-for-finding-arch.patch \
           file://0001-fix-create-thread-failed-in-unprivileged-process-BZ-.patch \
           "
S = "${WORKDIR}/glibc-${PV}"
B = "${WORKDIR}/build-${TARGET_SYS}"

PACKAGES_DYNAMIC = ""

# the -isystem in bitbake.conf screws up glibc do_stage
BUILD_CPPFLAGS = "-I${STAGING_INCDIR_NATIVE}"
TARGET_CPPFLAGS = "-I${STAGING_DIR_TARGET}${includedir}"

GLIBC_BROKEN_LOCALES = ""

GLIBCPIE ??= ""

EXTRA_OECONF = "--enable-kernel=${OLDEST_KERNEL} \
                --disable-profile \
                --disable-debug --without-gd \
                --enable-clocale=gnu \
                --with-headers=${STAGING_INCDIR} \
                --without-selinux \
                --enable-tunables \
                --enable-bind-now \
                --enable-stack-protector=strong \
                --with-default-link \
                ${@bb.utils.contains_any('SELECTED_OPTIMIZATION', '-O0 -Og', '--disable-werror', '', d)} \
                ${GLIBCPIE} \
                ${GLIBC_EXTRA_OECONF}"

#--disable-crypt
EXTRA_OECONF += "${@get_libc_fpu_setting(bb, d)}"

EXTRA_OECONF_append_x86 = " --enable-cet"
EXTRA_OECONF_append_x86-64 = " --enable-cet"

PACKAGECONFIG ??= "nscd memory-tagging"
PACKAGECONFIG[nscd] = "--enable-nscd,--disable-nscd"
PACKAGECONFIG[memory-tagging] = "--enable-memory-tagging,--disable-memory-tagging"

do_patch_append() {
    bb.build.exec_func('do_fix_readlib_c', d)
}

do_fix_readlib_c () {
	sed -i -e 's#OECORE_KNOWN_INTERPRETER_NAMES#${EGLIBC_KNOWN_INTERPRETER_NAMES}#' ${S}/elf/readlib.c
}

do_configure () {
# override this function to avoid the autoconf/automake/aclocal/autoheader
# calls for now
# don't pass CPPFLAGS into configure, since it upsets the kernel-headers
# version check and doesn't really help with anything
        (cd ${S} && gnu-configize) || die "failure in running gnu-configize"
        find ${S} -name "configure" | xargs touch
        CPPFLAGS="" oe_runconf
}

LDFLAGS += "-fuse-ld=bfd"
do_compile () {
	base_do_compile
	echo "Adjust ldd script"
	if [ -n "${RTLDLIST}" ]
	then
		prevrtld=`cat ${B}/elf/ldd | grep "^RTLDLIST=" | sed 's#^RTLDLIST="\?\([^"]*\)"\?$#\1#'`
		# remove duplicate entries
		newrtld=`echo $(printf '%s\n' ${prevrtld} ${RTLDLIST} | LC_ALL=C sort -u)`
		echo "ldd \"${prevrtld} ${RTLDLIST}\" -> \"${newrtld}\""
		sed -i ${B}/elf/ldd -e "s#^RTLDLIST=.*\$#RTLDLIST=\"${newrtld}\"#"
	fi
}

require glibc-package.inc

BBCLASSEXTEND = "nativesdk"
