# ── CodeBuild Project - 4 blocs (source , environment, artifacts, logs) ──────────────────────────

resource "aws_codebuild_project" "app_build" {
  name          = "${var.project}-${var.environment}-build"
  description   = "Build, test et push Docker de l'application"
  service_role  = var.codebuild_role_arn # vient du module iam
  build_timeout = 15                     # minutes — évite un build qui tourne indéfiniment

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    # Variables d'environnement disponibles dans TOUTES les phases du buildspec
    environment_variable {
      name  = "ECR_REPOSITORY_URL"
      value = var.ecr_repository_url # ex: 123456789012.dkr.ecr.eu-west-3.amazonaws.com/mon-repo
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "app/buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.project}-${var.environment}"
    }
  }

  tags = {
    Name        = "${var.project}-${var.environment}-build"
    Project     = var.project
    Environment = var.environment
  }
}