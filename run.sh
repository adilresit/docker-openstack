#!/bin/bash
set -x
keystone-all &
/etc/init.d/mysql start
/etc/init.d/apache2 start
/etc/init.d/memcached start
/etc/init.d/keystone start

keystone-manage db_sync

export OS_SERVICE_TOKEN=openstack
export OS_SERVICE_ENDPOINT=http://localhost:35357/v2.0

keystone tenant-create --name admin --description "Admin Tenant"
keystone user-create --name admin --pass admin --email admin@admin.com
keystone role-create --name admin
keystone role-create --name _member_
keystone user-role-add --user admin --tenant admin --role admin
keystone tenant-create --name service --description "Service Tenant"
keystone service-create --name keystone --type identity --description "OpenStack Identity"


keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ identity / {print $2}') \
  --publicurl http://localhost:5000/v2.0 \
  --internalurl http://localhost:5000/v2.0 \
  --adminurl http://localhost:35357/v2.0 \
  --region regionOne

/etc/init.d/supervisor start



