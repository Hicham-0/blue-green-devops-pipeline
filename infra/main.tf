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
  sns_topic_arn = module.sns.sns_topic_arn
}

module "cicd" {
  source = "./modules/cicd"

  project     = var.project
  environment = var.environment

  codebuild_role_arn    = module.iam.codebuild_role_arn
  codepipeline_role_arn = module.iam.codepipeline_role_arn
  ecr_repository_url    = module.ecr.repository_url
  artifact_bucket_id    = module.s3.bucket_id
  ecs_cluster_name      = module.ecs.cluster_name
  ecs_service_name      = module.ecs.service_name

  github_repository_id = "Hicham-0/blue-green-devops-pipeline"
  github_branch        = "main"
}

module "vpc" {
  source = "./modules/vpc"

  project     = var.project
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "alb" {
  source = "./modules/alb"

  project     = var.project
  environment = var.environment

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecs" {
  source = "./modules/ecs"

  project     = var.project
  environment = var.environment
  aws_region  = var.aws_region

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  alb_security_group_id = module.alb.alb_security_group_id
  target_group_blue_arn = module.alb.target_group_blue_arn
  alb_listener_arn      = module.alb.alb_listener_arn

  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn

  ecr_repository_url     = module.ecr.repository_url
  image_tag              = var.image_tag
  target_group_green_arn = module.alb.target_group_green_arn
  alb_listener_rule_arn  = module.alb.alb_listener_rule_arn
  ecs_bluegreen_role_arn = module.iam.ecs_bluegreen_role_arn
}

module "sns" {
  source = "./modules/sns"

  project     = var.project
  environment = var.environment

  notification_email = var.notification_email
  codepipeline_name   = module.cicd.pipeline_name
}