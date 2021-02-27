# 介绍
用于快速构建并部署FTP服务器

# 使用方法
- 方法一：使用CentOS7物理机、镜像直接执行install_ftp.sh脚本
1. 如果是物理机，创建/home/ftp目录，如果是使用Centos7镜像创建容器，建议将/home/ftp挂载到非/root的宿主机目录上
2. 确保宿主机和容器内可以使用yum，且与yum源通信良好
3. install_ftp.sh脚本拷贝到任意目录，执行即可，默认的用户名和密码是ftp和ftptest
4. 客户端安装ftp后，使用ftp [ftp的宿主机IP] 进行访问
   
- 方法二：使用使用此Dockerfile构建镜像或者使用构建好的镜像，使用以下命令部署ftp容器
1. 如未构建镜像，请使用构建命令docker build -t [自定义镜像名，如ftp:1.0] .
2. 以完成构建或已存在镜像情况下执行创建容器命令即可，其中/home/data/ftp:是宿主机上存放ftp文件的地址，请自行更改
docker run -tid --name="ftp" --privileged=true -v /home/data/ftp:/home/ftp --net=host  ftp:1.0  /usr/sbin/init

