FROM centos:7
ADD install_ftp.sh /home/install_ftp.sh
RUN chmod +x /home/install_ftp.sh
RUN source /home/install_ftp.sh
EXPOSE 21