Usage


1- Build your image with Dockerfile. Go to openstack-docker directory and run

    sudo docker build -t openstack-docker .

2- Run an instance 

    sudo docker run  <image_name> or <image_id>

3- Check openstack-docker container ip addres 

    sudo docker inspect <images_id> 

4- Connect dashborad 

    http://<container_ip>/horizon
    username:admin
    password:admin
