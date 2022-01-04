output "web_server_lb_dns_name" {
  value       = aws_lb.web_server_lb.dns_name
  description = "The domain name of the load balancer"
}