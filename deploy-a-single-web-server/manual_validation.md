# Test connection to web server

1. Retrieve the public DNS name for the web server created either via the GUI or CLI.
    - AWS CLI Command: **aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicDnsName" --output=text**

2. Send HTTP request to web server to validate user data script ran at boot.
    - Http request: **curl -X GET http://{public_DNS_name}:8080**

3. Validate expected output is returned.
    - Expected output: **Hello, World!**

