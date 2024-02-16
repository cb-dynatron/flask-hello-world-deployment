# url to access the alb
output "alb_url" {
  value = aws_lb.alb.dns_name
}
