#
# Generated by ros2recipe.py
#
# Copyright openeuler

inherit ros_distro_humble
inherit ros_superflore_generated

DESCRIPTION = "The lsm10_v2 package"
AUTHOR = "tongsky"
SECTION = "devel"
LICENSE = "TODO"
LIC_FILES_CHKSUM = "file://package.xml;beginline=8;endline=8;md5=2feaf30a620f46f06a4b016624acf46f"

ROS_CN = ""
PV = "2.0.0"
ROS_BPN = "lsm10-v2"

ROS_BUILD_DEPENDS = " \
    geometry-msgs \
    rclcpp \
    rclpy \
    rosidl-default-generators \
    rosidl-default-runtime \
    sensor-msgs \
    std-msgs \
    std-srvs \
    visualization-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
    rosidl-default-generators-native \
    rosidl-typesupport-fastrtps-cpp-native \
    rosidl-typesupport-fastrtps-c-native \
"

ROS_EXPORT_DEPENDS = " \
    geometry-msgs \
    rclcpp \
    rclpy \
    rosidl-default-generators \
    rosidl-default-runtime \
    sensor-msgs \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    geometry-msgs \
    rclcpp \
    rclpy \
    rosidl-default-generators \
    rosidl-default-runtime \
    sensor-msgs \
    std-msgs \
    std-srvs \
    visualization-msgs \
"

# Currently informational only -- see http://www.ros.org/reps/rep-0149.html#dependency-tags.
ROS_TEST_DEPENDS = " \
    ament-cmake-gtest \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
# Bitbake doesn't support the "export" concept, so build them as if we needed them to build this package (even though we actually
# don't) so that they're guaranteed to have been staged should this package appear in another's DEPENDS.
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

OPENEULER_LOCAL_NAME = "hieuler_3rdparty_sensors"
SRC_URI = " \
    file://${OPENEULER_LOCAL_NAME}/lidar/ls_lidar \
"

S = "${WORKDIR}/hieuler_3rdparty_sensors/lidar/ls_lidar"
DISABLE_OPENEULER_SOURCE_MAP = "1"
FILES:${PN} += "${datadir} ${libdir}/lsm10_v2/*"
ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

