provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "ec2_instance" {  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  ami           = "ami-029ed17b4ea379178" # AWS Marketplace to find AMI's
  instance_type = "t2.micro"              # AWS Free Tier EC2

  tags = {
    "Name" = "terraform-example" # Add Name to EC2 instance
  }
}
