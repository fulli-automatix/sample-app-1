resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.root}/ec2-access.pem.pub")
}

resource "aws_instance" "web_server" {
  for_each      = data.aws_subnet_ids.private_subnets.ids
  ami           = data.aws_ami.amazon_ami.id
  subnet_id     = each.value
  instance_type = "t2.micro"
  tags = merge(
    var.default_tags,
    {
      Name = "web-server-${each.key}"
    }
  )
  user_data = <<EOF
#!/bin/bash
echo "Installing httpd"
sudo yum update -y
sudo yum -y install httpd
echo "Hello world" >> /var/www/html/index.html
sudo service httpd start
EOF

  provisioner "local-exec" {
    command    = "echo `date`"
    on_failure = continue
  }
}
resource "aws_security_group" "ec2_sg" {
  name = "${var.default_tags["Environment"]}-ec2-sg"
  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [aws_security_group.lb_sg.id]
  }
  vpc_id = var.vpc_id

}
