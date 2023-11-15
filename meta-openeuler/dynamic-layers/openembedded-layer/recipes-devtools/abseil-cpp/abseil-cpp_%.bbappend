OPENEULER_SRC_URI_REMOVE = "https http git"

PV = "20230125.3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

SRC_URI = "file://abseil-cpp-${PV}.tar.gz \
        file://0001-absl-always-use-asm-sgidefs.h.patch \
        file://0002-Remove-maes-option-from-cross-compilation.patch \
        file://abseil-ppc-fixes.patch \
        file://0003-Remove-neon-option-from-cross-compilation.patch \
        file://0001-direct_mmap-Use-off_t-on-linux.patch \
        "

SRC_URI += " \
        file://abseil-cpp-20210324.2-sw.patch \
        "

EXTRA_OECMAKE += "-DABSL_ENABLE_INSTALL=ON"

S = "${WORKDIR}/abseil-cpp-${PV}"

# contains symbol link
INSANE_SKIP:${PN} += "dev-so"
FILES:${PN} += "${libdir}/libabsl_*.so*"
FILES:${PN}-dev += "${libdir}/pkgconfig"

# from Yocto 4.2, temporarily used until yocto is updated.
python package_do_pkgconfig () {
    import re

    packages = d.getVar('PACKAGES')
    workdir = d.getVar('WORKDIR')
    pkgdest = d.getVar('PKGDEST')

    shlibs_dirs = d.getVar('SHLIBSDIRS').split()
    shlibswork_dir = d.getVar('SHLIBSWORKDIR')

    pc_re = re.compile(r'(.*)\.pc$')
    var_re = re.compile(r'(.*)=(.*)')
    field_re = re.compile(r'(.*): (.*)')

    pkgconfig_provided = {}
    pkgconfig_needed = {}
    for pkg in packages.split():
        pkgconfig_provided[pkg] = []
        pkgconfig_needed[pkg] = []
        for file in sorted(pkgfiles[pkg]):
                m = pc_re.match(file)
                if m:
                    pd = bb.data.init()
                    name = m.group(1)
                    pkgconfig_provided[pkg].append(os.path.basename(name))
                    if not os.access(file, os.R_OK):
                        continue
                    with open(file, 'r') as f:
                        lines = f.readlines()
                    for l in lines:
                        m = field_re.match(l)
                        if m:
                            hdr = m.group(1)
                            exp = pd.expand(m.group(2))
                            if hdr == 'Requires':
                                pkgconfig_needed[pkg] += exp.replace(',', ' ').split()
                                continue
                        m = var_re.match(l)
                        if m:
                            name = m.group(1)
                            val = m.group(2)
                            pd.setVar(name, pd.expand(val))

    for pkg in packages.split():
        pkgs_file = os.path.join(shlibswork_dir, pkg + ".pclist")
        if pkgconfig_provided[pkg] != []:
            with open(pkgs_file, 'w') as f:
                for p in sorted(pkgconfig_provided[pkg]):
                    f.write('%s\n' % p)

    # Go from least to most specific since the last one found wins
    for dir in reversed(shlibs_dirs):
        if not os.path.exists(dir):
            continue
        for file in sorted(os.listdir(dir)):
            m = re.match(r'^(.*)\.pclist$', file)
            if m:
                pkg = m.group(1)
                with open(os.path.join(dir, file)) as fd:
                    lines = fd.readlines()
                pkgconfig_provided[pkg] = []
                for l in lines:
                    pkgconfig_provided[pkg].append(l.rstrip())

    for pkg in packages.split():
        deps = []
        for n in pkgconfig_needed[pkg]:
            found = False
            for k in pkgconfig_provided.keys():
                if n in pkgconfig_provided[k]:
                    if k != pkg and not (k in deps):
                        deps.append(k)
                    found = True
            if found == False:
                bb.note("couldn't find pkgconfig module '%s' in any package" % n)
        deps_file = os.path.join(pkgdest, pkg + ".pcdeps")
        if len(deps):
            with open(deps_file, 'w') as fd:
                for dep in deps:
                    fd.write(dep + '\n')

}
