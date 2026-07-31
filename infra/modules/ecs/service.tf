resource "aws_ecs_service" "app" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    strategy             = "BLUE_GREEN"
    bake_time_in_minutes = 1
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_blue_arn
    container_name   = "app"
    container_port   = 3000

    advanced_configuration {
      alternate_target_group_arn = var.target_group_green_arn
      production_listener_rule   = var.alb_listener_rule_arn
      role_arn                   = var.ecs_bluegreen_role_arn
    }
  }

  depends_on = [var.alb_listener_arn]

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }

  tags = {
    Name        = "${var.project}-service"
    Environment = var.environment
  }
}