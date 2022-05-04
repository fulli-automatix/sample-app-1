resource "aws_instance" "web_server" {
  for_each = data.aws_subnet_ids.private_subnets.ids
  ami = data.aws_ami.amazon_ami.id
  subnet_id = "${each.value}"
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
}
