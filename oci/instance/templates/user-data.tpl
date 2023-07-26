#! /bin/bash
apt-get update
apt-get -y install apache2
apt-get -y install iperf3 curl netcat
# Retrieve instance name and IP address from Azure metadata service
INSTANCE_NAME=$(curl -H "Authorization: Bearer Oracle" http://169.254.169.254/opc/v2/instance/hostname)
# INSTANCE_ID=$(curl -H "Authorization: Bearer Oracle" http://169.254.169.254/opc/v2/vnics/privateIp)
# Create index.html file with instance name and IP address
cat <<EOF > 
<!DOCTYPE html>
<html>
<body>
    <center>
    <h1><span style="color:Red">Fortinet</span> - Azure Linux VM</h1>
    <p></p>
    <hr/>
    <h2>OCI Instance Name: $INSTANCE_NAME</h2>
    <!-- <h2>OCI Instance ID: $INSTANCE_ID</h2> -->
    </center>
</body>
</html>
EOF