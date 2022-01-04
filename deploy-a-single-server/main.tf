provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "web_server" {  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  ami           = "ami-0cc14ee62f0703205" # AWS Marketplace to find AMI's - Ubuntu 18.04
  instance_type = "t2.micro"              # AWS Free Tier EC2

  tags = {
    "Name" = "terraform-example" # Add Name to EC2 instance
  }
}
