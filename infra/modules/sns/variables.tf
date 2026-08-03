variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "notification_email" {
  type        = string
  description = "Email qui recevra les notifications de pipeline"
}

variable "codepipeline_name" {
  type        = string
  description = "Nom de la pipeline à surveiller"
}