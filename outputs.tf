output "public_ip_ec2" {
  value = aws_instance.finditgeek_presentation_loadbalancer.public_ip
}