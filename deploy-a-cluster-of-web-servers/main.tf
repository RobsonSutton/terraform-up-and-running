provider "aws" {
  region = "eu-west-2"
}

resource "aws_launch_configuration" "web_server_lt" {     # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
  image_id        = "ami-0cc14ee62f0703205"               # AWS Marketplace to find AMI's - Ubuntu 18.04
  instance_type   = "t2.micro"                            # AWS Free Tier EC2 for use in Auto Scaling Group
  security_groups = [aws_security_group.web_server_sg.id] # Assign Security Group to ASG

  # Define bash script to run during instance boot
  user_data = <<-EOF
    #!/bin/bash
      echo "Hello, World!" > index.html
      nohup busybox httpd -f -p ${var.server_port} &
    EOF

  # Required when using a launch configuration with an auto scaling group to prevent deletion errors.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_server_asg" {                 # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
  launch_configuration = aws_launch_configuration.web_server_lt.name # Assign launch template to ASG
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids             # Set relevant default subnets (1 per AZ) for ASG to deploy to

  # Set range of instances within ASG
  min_size = 2
  max_size = 10

  # Add name tag to all instances within ASG
  tag {
    key                 = "Name"
    value               = "web-server-asg"
    propagate_at_launch = true
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