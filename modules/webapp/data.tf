data "aws_ami" "amazon_ami" {

  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

}

data "aws_vpc" "main_vpc" {
 id = var.vpc_id
}
data "aws_subnet_ids" "public_subnets" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Type"
    values = ["public-subnets"]
  }
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Type"
    values = ["private-subnets"]
  }
}