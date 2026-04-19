output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.docker_server.public_ip
}

output "application_url" {
  description = "The URL to access the deployed Nginx application"
  value       = "http://${aws_instance.docker_server.public_ip}"
}
