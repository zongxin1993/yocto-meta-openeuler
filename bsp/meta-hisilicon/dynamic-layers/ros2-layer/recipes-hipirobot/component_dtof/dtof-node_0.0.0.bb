#
# Generated by ros2recipe.py
#
# Copyright openeuler

inherit ros_distro_humble
inherit ros_superflore_generated

DESCRIPTION = "dtof-node"
AUTHOR = "lx"
SECTION = "devel"
LICENSE = "MulanPSL-2.0"
LIC_FILES_CHKSUM = "file://package.xml;beginline=8;endline=8;md5=782925c2d55d09052e1842a0b4886802"

ROS_CN = ""
PV = "0.0.0"
ROS_BPN = "dtof-node"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    std-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXPORT_DEPENDS = " \
    rclcpp \
    std-msgs \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    rclcpp \
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

OPENEULER_LOCAL_NAME = "hirobot_component_dtof"
SRC_URI = " \
    file://hirobot_component_dtof/dtof_ros_demo/src/dtof_node \
"

S = "${WORKDIR}/hirobot_component_dtof/dtof_ros_demo/src/dtof_node"
FILES:${PN} += "${datadir} ${libdir}"
DISABLE_OPENEULER_SOURCE_MAP = "1"
ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

