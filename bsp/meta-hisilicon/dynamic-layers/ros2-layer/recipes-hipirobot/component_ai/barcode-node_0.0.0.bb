# hieuler_component_ai/sample/barcode_detection/demo_ros2/barcode_node/barcode-node_0.0.0.bb 
#
# Generated by ros2recipe.py
#
# Copyright openeuler

inherit ros_distro_humble
inherit ros_superflore_generated

DESCRIPTION = "TODO: Package description"
AUTHOR = "root"
SECTION = "devel"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://package.xml;beginline=8;endline=8;md5=782925c2d55d09052e1842a0b4886802"

ROS_CN = ""
PV = "0.0.0"
ROS_BPN = "barcode-node"

ROS_BUILD_DEPENDS = " \
    builtin-interfaces \
    rosidl-default-runtime \
    rclcpp \
    barcode-interface \
    camera \
    mipi-camera \
    zxing \
    std-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
    rosidl-default-generators-native \
    rosidl-default-runtime \
    rosidl-adapter-native \
    ament-cmake-ros-native \
    rosidl-generator-c-native \
    rosidl-generator-cpp-native \
    rosidl-typesupport-fastrtps-c-native \
    rosidl-typesupport-fastrtps-cpp-native \
    rosidl-typesupport-introspection-cpp-native \
    rosidl-typesupport-cpp-native \
    rosidl-generator-py-native \
"

ROS_EXPORT_DEPENDS = " \
    rosidl-default-runtime \
    barcode-interface \
    camera \
    mipi-camera \
    zxing \
    std-msgs \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    builtin-interfaces \
    rosidl-default-runtime \
    rclcpp \
    barcode-interface \
    camera \
    mipi-camera \
    zxing \
    std-msgs \
"

# Currently informational only -- see http://www.ros.org/reps/rep-0149.html#dependency-tags.
ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
# Bitbake doesn't support the "export" concept, so build them as if we needed them to build this package (even though we actually
# don't) so that they're guaranteed to have been staged should this package appear in another's DEPENDS.
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

OPENEULER_LOCAL_NAME = "hieuler_component_ai"
SRC_URI = " \
    file://hieuler_component_ai/sample/barcode_detection/demo_ros2/barcode_node \
    file://hieuler_component_ai/sample/zxing/src/zxing-cpp-1.4.0.zip \
    file://hieuler_component_ai \
    file://barcode_node_fix.patch \
"

do_unpack:append() {
    bb.build.exec_func('do_copy_zxing_source', d)
}
 
do_copy_zxing_source() {
    if [ ! -e ${WORKDIR}/hieuler_component_ai/sample/zxing/src/zxing-cpp-1.4.0/CMakeLists.txt ];then
        mv ${WORKDIR}/zxing-cpp-1.4.0 ${WORKDIR}/hieuler_component_ai/sample/zxing/src
    fi
}

S = "${WORKDIR}/hieuler_component_ai/sample/barcode_detection/demo_ros2/barcode_node"
FILES:${PN} += "${datadir} ${libdir}/barcode_node/*"
DISABLE_OPENEULER_SOURCE_MAP = "1"
ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

