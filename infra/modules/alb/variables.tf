variable "project" {
  type        = string
  description = "Nom du projet, utilisé pour le naming"
}

variable "environment" {
  type        = string
  description = "Environnement (ex: production)"
}

variable "vpc_id" {
  type        = string
  description = "ID du VPC où déployer l'ALB"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Subnets publics pour l'ALB (au moins 2 AZ)"
}