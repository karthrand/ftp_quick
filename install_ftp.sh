vsftpd_conf="/etc/vsftpd/vsftpd.conf"

function replace(){
file=$1
oldpar=$2
newpar=$3
paraname=$4
if [ "${oldpar}" == "${newpar}" ];then
    echo -e "\033[32m ${file}文件的${paraname}参数无改动，跳过 \033[0m"  >> /home/ftp.log
else
    sed -i '/${paraname}/s/'${oldpar}'/'${newpar}'/' ${file}
    echo -e "\033[32m ${file}下${paraname}参数更新${oldpar}为${newpar} \033[0m" >> /home/ftp.log
fi

}

function installftp(){
yum -y install vsftpd
chkconfig vsftpd on
systemctl enable vsftpd.service
systemctl restart vsftpd.service
echo "ftp安装完成" >> /home/ftp.log
}

function remove(){
#用户移除包含#的开头注释参数
file=$1
paraname=$2
sed -i '/${paraname}=/s/^#//' ${file}
echo -e "\033[32m ${file}下${paraname}参数已去除注释 \033[0m" >> /home/ftp.log
}

function setting(){
#设置禁止匿名登陆用户登录
anonymous_enable_value=`cat ${vsftpd_conf} |grep anonymous_enable | cut -d "=" -f 2 |cut -d ":" -f 1`
replace ${vsftpd_conf} ${anonymous_enable_value} NO anonymous_enable

#设置限制用户访问家目录之外的地方
remove ${vsftpd_conf} chroot_local_user

#允许写入
echo "allow_writeable_chroot=YES" >> ${vsftpd_conf}

echo "ftp配置文件设置完成" >> /home/ftp.log
}

function setuser(){
#useradd -s /sbin/nologin -d /home/ftp/ ftp
usermod -d /home/ftp ftp
chown -R ftp /home/ftp
chmod 755 -R /home/ftp
chmod a-w /home/ftp
echo ftptest | passwd --stdin ftp
echo "ftp账户设置完成" >> /home/ftp.log
}

result=`netstat -ntlp |grep vsftpd`

if [[ ${result} == "" ]];then
installftp
setting
setuser
else 
    echo "ftp已安装，跳过安装过程" >> /home/ftp.log
fi