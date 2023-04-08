
echo 'docker deploy starting ...'
set -e   

export DOCKER_RAMDISK=true

if [ ! -d /etc/docker ]; then
	mkdir -p /etc/docker
fi

# docker仓库配置，可手动更改daemon.json，更改后需要重启docker
if [ -e ./daemon.json ]; then
	cp -f ./daemon.json /etc/docker/
fi

if [! -e ./mount_cgroup.sh ]; then
	echo 'mount_cgroup.sh not exist,can not mounting cgroup'
	exit 0
fi

sh ./mount_cgroup.sh

if [! -e ./docker-v20.10.2-dev_riscv64.deb ]; then
	echo 'docker-v20.10.2-dev_riscv64.deb not exist,stop docker deploy!'
	exit 0
fi

if [ -d ./docker_pkg ]; then
	rm -rf ./docker_pkg
fi

mkdir ./docker_pkg

dpkg -x ./docker-v20.10.2-dev_riscv64.deb ./docker_pkg

cp -f ./docker_pkg/usr/local/bin/* /usr/bin/
cp -f ./docker_pkg/usr/local/sbin/* /usr/bin/
cp -f ./docker_pkg/etc/systemd/system/* /etc/systemd/system/

echo 'run dockerd...'
/usr/bin/dockerd &

exit 0

