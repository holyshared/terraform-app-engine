output "project_id" {
  value       = module.web.project_id
  description = "project id"
}

output "backend_service_account_email" {
  value       = module.web.backend_service_account_email
  description = "email of backend service account"
}

output "backend_domain_resource_records" {
  value       = module.web.domain_resource_records
  description = "dns records of custom domain"
}
