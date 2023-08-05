output "project_id" {
  value       = module.web.project_id
  description = "project id"
}

output "backend_service_account_email" {
  value       = module.web.backend_service_account_email
  description = "email of backend service account"
}
