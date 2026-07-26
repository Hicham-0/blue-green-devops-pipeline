output "ecr_repository_url" {
  description = "URL du repository ECR — pour vérifier les images poussées"
  value       = module.ecr.repository_url
}

output "codebuild_project_name" {
  description = "Nom du projet CodeBuild — pour lancer un build manuel ou consulter les logs"
  value       = module.cicd.codebuild_project_name
}

output "codepipeline_name" {
  description = "Nom du pipeline — pour suivre son exécution dans la console"
  value       = module.cicd.pipeline_name
}

output "codestar_connection_arn" {
  description = "ARN de la connexion GitHub — à activer manuellement dans la console après le premier apply"
  value       = module.cicd.codestar_connection_arn
}

output "artifact_bucket_id" {
  description = "Nom du bucket S3 d'artefacts"
  value       = module.s3.bucket_id
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "URL d'accès à l'application via l'ALB"
}