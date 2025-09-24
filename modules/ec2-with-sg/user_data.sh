#!/bin/bash
yum update -y
yum install -y httpd

# Create a simple HTML page with deployment info
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Terraform Stack Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .info { background: #f0f0f0; padding: 20px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>Terraform Stack Demo Server</h1>
    <div class="info">
        <h3>Deployment Information</h3>
        <p><strong>Project:</strong> ${project}</p>
        <p><strong>Environment:</strong> ${environment}</p>
        <p><strong>AWS Region:</strong> ${region}</p>
        <p><strong>Instance:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
        <p><strong>Local IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)</p>
        <p><strong>Public IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>
        <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
    </div>
    <p>This server was deployed using Terraform Stacks with region-specific providers!</p>
</body>
</html>
EOF

systemctl start httpd
systemctl enable httpd

# Create a simple deployment info log
echo "=== Terraform Stack Deployment ===" >> /var/log/deployment.log
echo "Project: ${project}" >> /var/log/deployment.log
echo "Environment: ${environment}" >> /var/log/deployment.log
echo "Region: ${region}" >> /var/log/deployment.log
echo "Deployed at: $(date)" >> /var/log/deployment.log
echo "Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> /var/log/deployment.log