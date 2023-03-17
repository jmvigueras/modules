#cloud-config
package_upgrade: true
packages:
  - curl
  - apt-transport-https
  - ca-certificates
  - software-properties-common
runcmd:
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - DEBIAN_FRONTEND=noninteractive apt update
  - DEBIAN_FRONTEND=noninteractive apt -y install docker-ce
  - DEBIAN_FRONTEND=noninteractive apt -y install python3-pip
  - docker run -d --restart always -p 80:80 jviguerasfortinet/docker:web-srv-python