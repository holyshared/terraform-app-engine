variable "credentials" {
  description = "credentials for project"
}

variable "organization_id" {
  description = "organization id"
}

variable "billing_account" {
  description = "billing account"
}

variable "folder_id" {
  description = "folder id"
}

variable "environment" {
  description = "environment"
}

variable "region" {
  description = "region"
  default     = "asia-northeast1"
}

variable "build_branch" {
  description = "branch for build"
  default = null
}

variable "domain" {
  description = "domain"
}

variable "env_secret_variables" {
  type = list(object({
    env_name = string
    secret_id = string
  }))
  description = "enviroment secret variables for container"
}

variable "env_variables" {
  type = list(object({
    env_name = string
    value = string
  }))
  description = "enviroment variables for container"
}
