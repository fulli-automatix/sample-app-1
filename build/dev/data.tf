data "aws_ami" "amazon_ami" {

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["aws-elasticbeanstalk-amzn-*"]
  }

}

data "aws_vpc" "main_vpc" {
  id = var.vpc_id
}
data "aws_subnet_ids" "public_subnets" {
  vpc_id = var.vpc_id

  tags = {
    Type = "public-subnets"
  }
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = var.vpc_id

  tags = {
    Type = "private-subnets"
  }
}

data "terraform_remote_state" "shared-infra" {
  backend = "s3"
  config = {
    bucket = "shared-tf-states-912969828712"
    key    = "shared-infra-dev"
    region = "eu-west-1"
  }

}