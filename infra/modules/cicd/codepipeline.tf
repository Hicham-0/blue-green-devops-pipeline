
# ── GitHub Connection (CodeStar) ───────────────────────────────

resource "aws_codestarconnections_connection" "github" {
  name          = "${var.project}-github-connection"
  provider_type = "GitHub"
}



# ── CodePipeline ───────────────────────────────────────────────

resource "aws_codepipeline" "app_pipeline" {
  name     = "${var.project}-${var.environment}-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.artifact_bucket_id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = var.github_repository_id
        BranchName       = var.github_branch
        DetectChanges    = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.app_build.name
      }
    }
  }

  tags = {
    Name        = "${var.project}-${var.environment}-pipeline"
    Project     = var.project
    Environment = var.environment
  }
}