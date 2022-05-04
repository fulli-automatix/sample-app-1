output "web_server_instance_ids" {

  value = [
    for instance in aws_instance.web_server : instance.id
  ]
}