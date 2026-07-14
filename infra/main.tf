module "s3" {
  source = "./modules/s3"

  project     = var.project
  environment = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  project     = var.project
  environment = var.environment
}

module "iam" {
  source = "./modules/iam"

  project     = var.project
  environment = var.environment

  ecr_repository_arn           = module.ecr.repository_arn
  pipeline_artifact_bucket_arn = module.s3.bucket_arn
}

module "cicd" {
  source = "./modules/cicd"

  project     = var.project
  environment = var.environment

  codebuild_role_arn    = module.iam.codebuild_role_arn
  codepipeline_role_arn = module.iam.codepipeline_role_arn
  ecr_repository_url    = module.ecr.repository_url
  artifact_bucket_id    = module.s3.bucket_id

  github_repository_id = "Hicham-0/blue-green-devops-pipeline"
  github_branch        = "main"
}