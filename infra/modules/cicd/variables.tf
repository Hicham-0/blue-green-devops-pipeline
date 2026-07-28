variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "codebuild_role_arn" {
  type        = string
  description = "ARN du rôle IAM CodeBuild (module iam)"
}

variable "ecr_repository_url" {
  type        = string
  description = "URL du repository ECR (module ecr)"
}

variable "codepipeline_role_arn" {
  type        = string
  description = "ARN du rôle IAM CodePipeline (module iam)"
}

variable "github_repository_id" {
  type        = string
  description = "Format 'owner/repo', ex: Hicham-0/blue-green-devops-pipeline"
}

variable "github_branch" {
  type        = string
  default     = "main"
  description = "Branche déclenchant le pipeline"
}

variable "artifact_bucket_id" {
  type        = string
  description = "Nom du bucket S3 d'artefacts (module s3)"
}
variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}