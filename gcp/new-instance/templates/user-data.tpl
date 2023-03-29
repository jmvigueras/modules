#! /bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo apt-get install -y iperf iperf3
# Retrieve instance name and IP address from Azure metadata service
INSTANCE_NAME=$(curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/name")
INSTANCE_IP=$(curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip" | awk -F'[/:]' '{print $4}')
# Create index.html file with instance name and IP address
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html>
<body>
    <center>
    <h1><span style="color:Red">Fortinet</span> - GCP Linux VM</h1>
    <p></p>
    <hr/>
    <h2>EC2 Instance Name: $INSTANCE_NAME</h2>
    <h2>EC2 Instance IP: $INSTANCE_IP</h2>
    </center>
</body>
</html>
EOF
sudo systemctl restart apache2