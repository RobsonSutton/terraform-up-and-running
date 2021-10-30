provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "ec2_instance" {                       # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  ami                    = "ami-003eefed9ba71bcc0"             # AWS Marketplace to find AMI's
  instance_type          = "t2.micro"                          # AWS Free Tier EC2
  vpc_security_group_ids = [aws_security_group.sg_instance.id] # References create implicit dependancies for execution (view via: terraform graph)

  # Add script creating web server to run on startup
  user_data = <<EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    "Name" = "terraform-example" # Add Name to EC2 instance
  }
}

resource "aws_security_group" "sg_instance" { # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  name = "terraform-example-sg"

  # Setup inbound security group rule
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = var.server_port
    protocol    = "tcp"
    to_port     = var.server_port
  }
}