variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "ecr_repository_arn" {
  type        = string
  description = "ARN du repository ECR, pour scoper les permissions push/pull"
}

variable "pipeline_artifact_bucket_arn" {
  type        = string
  description = "ARN du bucket S3 d'artefacts CodePipeline"
}

variable "sns_topic_arn" {
  type        = string
  description = "ARN du topic SNS de notifications, pour lui attacher la policy EventBridge"
}

variable "codebuild_project_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_task_family" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}

variable "alb_listener_rule_arn" {
  type = string
}

variable "codestar_connection_arn" {
  type = string
}

variable "ecs_log_group_arn" {
  type = string
}