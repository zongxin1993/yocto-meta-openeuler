#!/usr/bin/env python3

import os
import docker
from threading import Thread

class DockerImage:

    REPOSITORY  :   str
    TAG         :   str
    IMAGE_ID    :   str
    CREATED     :   str
    SIZE        :   str


class DockerProxy(object):

    def __init__(self) -> None:
        self._client = docker.from_env()
    
    def __del__(self) -> None:
        self._client = None

    # 获取镜像列表
    def get_images(self) -> list[DockerImage]:
        images = self._client.images
        imageList = []
        for image in images.list():
            for tag in image.attrs['RepoTags']:
                objImage = DockerImage
                objImage.REPOSITORY = tag.split(':')[0]
                objImage.TAG = tag.split(':')[1]
                objImage.IMAGE_ID = image.short_id
                objImage.CREATED = image.attrs["Created"]
                objImage.SIZE = image.attrs['Size']
                imageList.append(objImage)
        return imageList

    # 删除容器
    def rm_container(self, container_id : str = "", container = None):          
        self._client.api.remove_container(container_id)

    # 删除镜像
    def rm_image(self):
        pass

    # 获取容器状态
    def get_container_info(self, container_id : str = "", container = None):
        pass

    # 开始容器
    def start_container(self, container_id : str = "", container = None):
        # containerObj = self.get_container_by_id(container_id = container_id)
        self._client.api.start(container_id)

    # 获取某个正在运行容器
    def get_container_by_id(self, container_id):
        return self._client.containers.get(container_id = container_id)

    # 创建可交互的容器
    def run_container_with_tty(self, image_name : str, command = None, user = None, work_dir = None, volume = None):
        container = self._client.containers.run(
            image_name, 
            stdin_open = True, 
            tty = True, 
            command = "bash",
            detach = True,
            user = user,
            working_dir = work_dir,
            volumes = volume
            )

        s = container.attach_socket(params = {'stdin': True, 'stdout': True, 'stream': True})

        def write_command(s):
             while True:
                command = input()
                command = command + "\n"
                os.write(s.fileno(), command.encode())
    
        def read_output(s):
            while True:
                output = os.read(s.fileno(), 10000).decode()
                print(output)

        write_c = Thread(target=write_command, args=(s,))
        write_c.start()

        read_c = Thread(target=read_output, args=(s,))
        read_c.start()

        if command != None:
            command = command + "\n"
            os.write(s.fileno(), command.encode())
            

    # 创建容器（可执行命令，可执行脚本）
    def run_container(self, image_name : str, commands = None, volumes = None, stream = False, work_dir = None, user = None):
        container = self._client.containers.run(
            image_name, 
            command = commands, 
            volumes = volumes, 
            stream = stream, 
            working_dir = work_dir, 
            user = user,
            entrypoint = "bash",
            detach = True,
            remove = True,
            stderr = True)
        # print(container)
        if stream == True:
            for line in container.logs(stream = True):
                print(line.decode())
        else:
            print(container.logs().decode())
        
    
