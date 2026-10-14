variable "project_id" {
  description = "ID do Projeto na GCP"
  type        = string
}

variable "region" {
  description = "Região padrão dos recursos"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Ambiente do projeto (ex: prod, staging)"
  type        = string
  default     = "prod"
}