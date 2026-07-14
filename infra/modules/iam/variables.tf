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

