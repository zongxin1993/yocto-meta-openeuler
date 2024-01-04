# add tools
IMAGE_INSTALL += " \
wpa-supplicant \
"

# all 3403 app
IMAGE_INSTALL += " \
i2c-soft \
v4l-utils \
hostapd \
${@bb.utils.contains("DISTRO_FEATURES", "ros", " \
ai-demolib \
mipi-ffmpeglib \
object-node \
gst-node \
pose-srv-node \
robot-det-node \
robot-localization \
joint-state-publisher \
astra-camera-msgs \
astra-camera-raw \
depth-image \
depth-image-proc \
depthimage-to-laserscan \
fitxxx \
imu-calib \
lsm10-v2 \
serial-imu \
sllidar-ros2 \
wr-ls-udp \
ydlidar-ros2-driver \
frame-relationship \
hirobot-cartographer \
costmap-converter \
costmap-converter-msgs \
teb-local-planner \
teb-msgs \
barcode-interface \
barcode-node \
camera \
mipi-camera \
zxing \
hibot-user-driver \
astra-camera \
dsp-bin \
depth-mini-seg \
get-pose-msg \
hirobot-base \
hirobot-bringup \
hirobot-depth-camera \
hirobot-description \
hirobot-get-goal-clear \
hirobot-goal-process \
hirobot-msgs \
hirobot-navigation2-teb \
hirobot-tof-plane-seg \
nav2-ipa \
person-position-ack \
robot-charge-control \
robot-init-pose \
bot-bringup \
bot-model \
diff-driver \
robot-bringup \
ros2-control-robot \
ros2-wheeltec-robot \
serial \
serial-protocol-v1 \
tf2-tools \
turn-on-wheeltec-robot \
ultra \
", "", d)}"

TOOLCHAIN_TARGET_TASK += " ${@bb.utils.contains("DISTRO_FEATURES", "ros", " \
hibot-user-driver-staticdev \
", "", d)}"

TOOLCHAIN_TARGET_TASK += " ${@bb.utils.contains("DISTRO_FEATURES", "ros", " \
json-c-staticdev \
gmp-staticdev \
libsqlite3-staticdev \
openamp-staticdev \
qhull-staticdev \
libusb-compat-staticdev \
libsepol-staticdev \
libmetal-staticdev \
shadow-staticdev \
libseccomp-staticdev \
bzip2-staticdev \
lua-staticdev \
protobuf-c-staticdev \
libyaml-staticdev \
openssl-staticdev \
libpython3-staticdev \
libestr-staticdev \
nettle-staticdev \
libwebp-staticdev \
e2fsprogs-staticdev \
zlib-staticdev \
glibc-external-staticdev \
audit-staticdev \
popt-staticdev \
libselinux-staticdev \
libogg-staticdev \
zstd-staticdev \
sysfsutils-staticdev \
libidn2-staticdev \
python3-numpy-staticdev \
cjson-staticdev \
cartographer-ros-staticdev \
libtool-staticdev \
cairo-staticdev \
libstdc++-staticdev \
libitm-staticdev \
libgomp-staticdev \
libatomic-staticdev \
bind-dhclient-staticdev \
attr-staticdev \
acl-staticdev \
yajl-staticdev \
tcl-staticdev \
cracklib-staticdev \
procps-staticdev \
libjpeg-turbo-staticdev \
libunistring-staticdev \
libffi-staticdev \
readline-staticdev \
elfutils-staticdev \
libuv-staticdev \
libusb1-staticdev \
gdbm-staticdev \
ncurses-staticdev \
libcap-staticdev \
libwrap-staticdev \
libnsl2-staticdev \
libgfortran-external-staticdev \
libarchive-staticdev \
libpcap-staticdev \
libevent-staticdev \
util-linux-staticdev \
libtirpc-staticdev \
freetype-staticdev \
costmap-queue-staticdev \
libunwind-staticdev \
libtheora-staticdev \
curl-staticdev \
lcr-staticdev \
libcap-ng-staticdev \
libsodium-staticdev \
libnl-staticdev \
util-linux-libuuid-staticdev \
libsemanage-staticdev \
cartographer-staticdev \
binutils-staticdev \
ceres-solver-staticdev \
xz-staticdev \
libpcre2-staticdev \
libaio-staticdev \
foonathan-memory-staticdev \
libuvc-staticdev \
libpwquality-staticdev \
zeromq-staticdev \
boost-staticdev \
libatomic-ops-staticdev \
lzo-staticdev \
libfastjson-staticdev \
libflann-staticdev \
protobuf-staticdev \
googletest-staticdev \
libpng-staticdev \
", "", d)}"
