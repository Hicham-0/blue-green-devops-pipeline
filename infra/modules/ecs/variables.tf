variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "VPC où déployer les tasks"
}

variable "alb_security_group_id" {
  type        = string
  description = "SG de l'ALB, pour autoriser l'ingress vers les tasks"
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "aws_region" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_blue_arn" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}