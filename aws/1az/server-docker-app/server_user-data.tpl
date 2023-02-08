#!/bin/bash
# Install neccesary packages
yum update -y
amazon-linux-extras install -y docker
yum install -y jq
yum install httpd -y
yum install -y git

# Clone git repo and copy to html folder and docker folder
#cd /tmp
#git clone ${app_github_uri}
#cp -r .${app_github_path}www/* /var/www
#cp -r .${app_github_path}docker /var

# Start Apache server and fix permissions
systemctl start httpd
systemctl enable httpd
chkconfig httpd on
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Start Docker daemon
service docker start
chkconfig docker on
usermod -a -G docker ec2-user

# Create docker-compose.yml
#cd /var/docker
#touch docker-compose.yml
#cat > docker-compose.yml <<EOF
#${docker_file}
#EOF

# Default docker-compose
mkdir /var/docker
cd /var/docker
touch docker-compose.yml
cat > docker-compose.yml << EOF
version: '3.8' 
services:
  web:
    image: httpd:latest
    container_name: web
    restart: always
    ports:
      - "8000:80"
    stdin_open: true
    tty: true
EOF

# Install Docker compose
cd /home/ec2-user
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose -f /var/docker/docker-compose.yml up -d