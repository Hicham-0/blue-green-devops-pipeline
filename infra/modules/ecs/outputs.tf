output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_tasks_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}
output "service_name" {
  value = aws_ecs_service.app.name
}
output "ecs_log_group_arn" {
  value = aws_cloudwatch_log_group.app.arn
}
output "task_family" {
  value = aws_ecs_task_definition.app.family
}