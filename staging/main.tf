module "web" {
  source = "../modules/web"

  credentials = var.credentials

  organization_id = var.organization_id
  billing_account = var.billing_account
  folder_id       = var.folder_id
  environment     = "staging"

  build_branch = "^develop$"
  domain       = var.domain

  env_variables        = var.env_variables
  env_secret_variables = var.env_secret_variables
}