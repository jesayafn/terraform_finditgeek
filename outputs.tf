output "public_ip_loadbalancer" {
  value = aws_instance.finditgeek_presentation_loadbalancer.public_ip
}