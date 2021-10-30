provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "ec2_instance" {                       # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  ami                    = "ami-003eefed9ba71bcc0"             # AWS Marketplace to find AMI's
  instance_type          = "t2.micro"                          # AWS Free Tier EC2
  vpc_security_group_ids = [aws_security_group.sg_instance.id] # References create implicit dependancies for execution (view via: terraform graph)

  # Add script to run on startup
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    "Name" = "terraform-example" # Add Name to EC2 instance
  }
}

resource "aws_security_group" "sg_instance" {
  name = "terraform-example-sg"

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
  } 
}