data "aws_vpc" "default" { # Retrieve default VPC
  default = true
}

data "aws_subnet_ids" "default" { # Retrieve default subnet id's for default VPC
  vpc_id = data.aws_vpc.default.id
}