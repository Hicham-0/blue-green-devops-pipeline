
output "codebuild_project_name" {
  value = aws_codebuild_project.app_build.name
}

output "pipeline_name" {
  value = aws_codepipeline.app_pipeline.name
}

output "codestar_connection_arn" {
  value = aws_codestarconnections_connection.github.arn
}
output "codebuild_project_arn" {
  value = aws_codebuild_project.app_build.arn
}