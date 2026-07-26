output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "DNS name de l'ALB, pour accéder à l'application"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "SG de l'ALB, référencé par le module ecs pour l'ingress des tasks"
}

output "target_group_blue_arn" {
  value = aws_lb_target_group.blue.arn
}

output "target_group_green_arn" {
  value = aws_lb_target_group.green.arn
}
output "alb_listener_arn" {
  value       = aws_lb_listener.http.arn
  description = "ARN du listener HTTP, utilisé comme dépendance par le service ECS"
}