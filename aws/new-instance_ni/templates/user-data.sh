#!/bin/bash
# Install necessary packages
apt update -y
apt install -y iperf3
apt install -y apache2
# PHP script to display Instance ID and Availability Zone
export INSTANCEID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
export AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<body>
    <center>
    <h1><span style="color:Red">Fortinet</span> - Ubuntu VM</h1>
    <p></p>
    <hr/>
    <h2>EC2 Instance ID: $INSTANCEID</h2>
    <h2>Availability Zone: $AZ</h2>
    </center>
</body>
</html>
EOF