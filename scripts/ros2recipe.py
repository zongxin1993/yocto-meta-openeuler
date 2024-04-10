# -*- coding: utf-8 -*-

import sys
import hashlib
import xml.etree.ElementTree as ET
from defusedxml.ElementTree import parse

try:
    xml_path = sys.argv[1]
    local_name = sys.argv[2]
except Exception as e:
    print("Input Error:",e)

workdir = xml_path.replace("/package.xml","")
component = ''

pkg_name = ''
version = ''
license = ''
description = ''
author = ''
build_type = ''
distributor = "openeuler"
maintainer = ""
rosdistro = "humble"
homepage = ''

deps = set()
export_deps = set()
buildtool_export_native_deps = set()
exec_deps = set()
test_deps = set()
buildtool_native_deps = set()

src_uri = set()
src_uri.add('file://' + workdir)

def get_top_inherit_line():
    ret = 'inherit ros_distro_{0}\n'.format(rosdistro)
    ret += 'inherit ros_superflore_generated\n\n'
    return ret

def get_bottom_inherit_line():
    ret = 'inherit ros_${ROS_BUILD_TYPE}\n'
    return ret

def get_license_line():  
    license_line = ''  
    license_md5 = ''  
    try:  
        with open(xml_path, 'r', encoding='utf-8') as file:  
            for i, line in enumerate(file, 1):  
                if 'license' in line:  
                    license_line = str(i)  
                    md5 = hashlib.md5()  
                    md5.update(line.encode())  # No need to add a newline here, as file lines include it  
                    license_md5 = md5.hexdigest()  
                    break  
    except FileNotFoundError:  
        print(f"File not found: {xml_path}")  
    except IOError as e:  
        print(f"I/O error while reading the file: {e}")  
    except OSError as e:  
        print(f"OS error while opening the file: {e}")  
    return license_line, license_md5

def get_spacing_prefix():
    return '\n' + ' ' * 4

def generate_multiline_variable(var, container, sort=True, key=None):
    if sort:
        """
        TODO(herb-kuta-lge): Have default <key> drop trailing '}' so that
        "${..._foo-native}" sorts after "${..._foo}".
        """
        container = sorted(container, key=key)
    assignment = '{0} = "'.format(var)
    expression = '"\n'
    if container:
        expression = ' \\' + get_spacing_prefix()
        expression += get_spacing_prefix().join(
            [item + ' \\' for item in container]) + '\n"\n'
    return assignment + expression

tree = parse(xml_path)
package_root = tree.getroot()

for info in package_root.findall('name'):
    pkg_name = info.text.replace('_','-')
for info in package_root.findall('version'):
    version = info.text
for info in package_root.findall('description'):
    description = info.text
for info in package_root.findall('license'):
    license = info.text.replace(' ','-')
for info in package_root.findall('maintainer'):
    maintainer = info.text
for info in package_root.findall('author'):
    author = info.text + ", " + author
for bds in package_root.findall('export'):
    for info in bds.findall('build_type'):
        build_type = info.text
        break
for info in package_root.findall('url'):
    homepage = info.text
    break

for info in package_root.findall('depend'):
    pkgn = info.text.replace('_','-')
    if pkgn not in deps:
        deps.add(pkgn)
for info in package_root.findall('build_depend'):
    pkgn = info.text.replace('_','-')
    if pkgn not in deps:
        deps.add(pkgn)
for info in package_root.findall('exec_depend'):
    pkgn = info.text.replace('_','-')
    if pkgn not in exec_deps:
        exec_deps.add(pkgn)
    if pkgn not in deps:
        deps.add(pkgn)
for info in package_root.findall('test_depend'):
    pkgn = info.text.replace('_','-')
    if pkgn not in test_deps:
        test_deps.add(pkgn)
for info in package_root.findall('build_export_depend'):
    pkgn = info.text.replace('_','-')
    if pkgn not in export_deps:
        export_deps.add(pkgn)
for info in package_root.findall('buildtool_depend'):
    pkgn = info.text.replace('_','-')
    if pkgn not in buildtool_native_deps:
        buildtool_native_deps.add(pkgn + "-native")
for info in package_root.findall('buildtool_export_depend'):
    pkgn = info.text.replace('_','-')
    if pkgn not in buildtool_export_native_deps:
        buildtool_export_native_deps.add(pkgn + "-native")

bb_name = workdir + "/" + pkg_name + "_" + version + ".bb"

ret = "# " + bb_name + " \n#\n"
ret += "# Generated by ros2recipe.py\n#\n"
ret += "# Copyright " + distributor + "\n\n"
ret += get_top_inherit_line()
# description
if description:
    description = description.replace('\n', ' ')
    ret += 'DESCRIPTION = "' + description + '"\n'
else:
    ret += 'DESCRIPTION = "None"\n'
# author
ret += 'AUTHOR = "' + maintainer + '"\n'
if author:
    ret += 'ROS_AUTHOR = "' + author + '"\n'
if homepage:
    ret += 'HOMEPAGE = "' + homepage + '"\n'
# section
ret += 'SECTION = "devel"\n'
# license
license_line, license_md5 = get_license_line()
ret += 'LICENSE = "' + license + '"\n'
ret += 'LIC_FILES_CHKSUM = "file://package.xml;beginline='
ret += str(license_line)
ret += ';endline='
ret += str(license_line)
ret += ';md5='
ret += str(license_md5)
ret += '"\n\n'
ret += 'ROS_CN = "' + component + '"\n'
ret += 'PV = "' + version + '"\n'
ret += 'ROS_BPN = "' + pkg_name + '"\n\n'

ret += generate_multiline_variable(
    'ROS_BUILD_DEPENDS', deps) + '\n'
ret += generate_multiline_variable(
    'ROS_BUILDTOOL_DEPENDS', buildtool_native_deps) + '\n'
ret += generate_multiline_variable(
    'ROS_EXPORT_DEPENDS', export_deps.union(deps)) + '\n'
ret += generate_multiline_variable(
    'ROS_BUILDTOOL_EXPORT_DEPENDS',
    buildtool_export_native_deps) + '\n'
ret += generate_multiline_variable(
    'ROS_EXEC_DEPENDS', exec_deps.union(deps)) + '\n'
ret += '# Currently informational only -- see '
ret += 'http://www.ros.org/reps/rep-0149.html#dependency-tags.\n'
ret += generate_multiline_variable(
    'ROS_TEST_DEPENDS', test_deps) + '\n'

ret += 'DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"\n'
ret += '# Bitbake doesn\'t support the "export" concept, so build them'
ret += ' as if we needed them to build this package (even though we'
ret += ' actually\n# don\'t) so that they\'re guaranteed to have been'
ret += ' staged should this package appear in another\'s DEPENDS.\n'
ret += 'DEPENDS += "${ROS_EXPORT_DEPENDS} '
ret += '${ROS_BUILDTOOL_EXPORT_DEPENDS}"\n\n'
ret += 'RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"' + '\n\n'
# SRC_URI
ret += 'OPENEULER_LOCAL_NAME = "' + local_name + '"\n'

ret += generate_multiline_variable(
    'SRC_URI', src_uri) + '\n'
ret += 'S = "${WORKDIR}/' + workdir + '"\n'
ret += 'FILES:${PN} += "${datadir} ${libdir}"\n'
ret += 'DISABLE_OPENEULER_SOURCE_MAP = "1"\n'
ret += 'ROS_BUILD_TYPE = "' + build_type + '"\n'
# Inherits
ret += '\n' + get_bottom_inherit_line()
print(ret)
