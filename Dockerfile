FROM	ubuntu:15.04
MAINTAINER	<adilresitdursun>


# Update package list and upgrade the ubuntu
RUN apt-get update
RUN apt-get -y upgrade

# Install openssh server
RUN apt-get install -y openssh-server

# Configure openssh server
RUN mkdir /var/run/sshd
RUN echo 'root:123' |chpasswd
RUN echo 'PermitRootLogin yes' > /etc/ssh/sshd_config  

#supervisor 
RUN apt-get install -y supervisor

#mysql 
RUN apt-get install -y mariadb-server python-mysqldb

RUN mysqld_safe & sleep 3 && \
mysql -u root --host=localhost -e "create database keystone" && \
mysql -u root --host=localhost -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'openstack'" && \
mysql -u root --host=localhost -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openstack'"

RUN  apt-get install -y keystone python-keystoneclient
COPY keystone.conf /etc/keystone/keystone.conf
COPY run.sh /run.sh
RUN chmod +x /run.sh
ADD keystone.conf keystone.conf
COPY keystone.conf /etc/keystone/keystone.conf
ADD supervisord.conf supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


#horizon install
RUN apt-get update
RUN apt-get install -y   apache2 memcached libapache2-mod-wsgi openstack-dashboard
RUN apt-get install -y python-memcache python-django-nova 
RUN apt-get remove -y openstack-dashboard-ubuntu-theme




EXPOSE 5000
EXPOSE 35357
EXPOSE 80
EXPOSE 3306
EXPOSE 11211


ENTRYPOINT ["/run.sh"]

VOLUME ["/etc/supervisor/conf.d"]
WORKDIR /etc/supervisor/conf.d
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]







