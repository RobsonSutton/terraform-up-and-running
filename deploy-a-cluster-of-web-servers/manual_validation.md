# Test connection to web server

1. Retrieve the public DNS names for the web servers created by the ASG either via the GUI or CLI.
    - AWS CLI Command: **aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicDnsName" --output=text**

2. Send HTTP request to each web server to validate user data script ran at boot.
    - Http request: **curl -X GET http://{public_DNS_name}:8080**

3. Validate expected output is returned.
    - Expected output: **Hello, World!**

