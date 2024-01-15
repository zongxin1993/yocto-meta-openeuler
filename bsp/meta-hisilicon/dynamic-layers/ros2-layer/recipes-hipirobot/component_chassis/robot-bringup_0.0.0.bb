#
# Generated by ros2recipe.py
#
# Copyright openeuler

inherit ros_distro_humble
inherit ros_superflore_generated

DESCRIPTION = "ROS2 robot_bringup for robot_control"
AUTHOR = "wheeltec"
SECTION = "devel"
LICENSE = "None"
LIC_FILES_CHKSUM = "file://package.xml;beginline=8;endline=8;md5=782925c2d55d09052e1842a0b4886802"

ROS_CN = ""
PV = "0.0.0"
ROS_BPN = "robot-bringup"

ROS_BUILD_DEPENDS = " \
    ros2-wheeltec-robot \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXPORT_DEPENDS = " \
    ros2-wheeltec-robot \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    ros2-wheeltec-robot \
"

# Currently informational only -- see http://www.ros.org/reps/rep-0149.html#dependency-tags.
ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
    boost \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
# Bitbake doesn't support the "export" concept, so build them as if we needed them to build this package (even though we actually
# don't) so that they're guaranteed to have been staged should this package appear in another's DEPENDS.
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

OPENEULER_LOCAL_NAME = "hieuler_component_chassis"
SRC_URI = " \
    file://${OPENEULER_LOCAL_NAME}/uart/robot_bringup \
"

S = "${WORKDIR}/hieuler_component_chassis/uart/robot_bringup"
FILES:${PN} += "${datadir}"
DISABLE_OPENEULER_SOURCE_MAP = "1"
ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

