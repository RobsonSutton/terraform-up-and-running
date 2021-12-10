provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "web_server" {                           # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  ami                    = "ami-0cc14ee62f0703205"               # AWS Marketplace to find AMI's - Ubuntu 18.04
  instance_type          = "t2.micro"                            # AWS Free Tier EC2
  vpc_security_group_ids = [aws_security_group.web_server_sg.id] # Assign Security Group to Web Server

  # Define bash script to run during instance boot
  user_data = <<-EOF
    #!/bin/bash
      echo "Hello, World!" > index.html
      nohup busybox httpd -f -p ${var.server_port} &
    EOF

  tags = {
    "Name" = "web-server" # Add Name to EC2 instance
  }
}

resource "aws_security_group" "web_server_sg" { # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  name = "web-server-sg"

  # Define Security Group ingress rule for port 8080
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }
}