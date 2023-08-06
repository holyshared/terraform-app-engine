output "project_id" {
  value       = module.project.project_id
  description = "project id"
}

output "backend_service_account_email" {
  value       = google_service_account.backend.email
  description = "email of backend service account"
}

output "domain_resource_records" {
  value       = google_app_engine_domain_mapping.default.resource_records
  description = "dns records of custom domain"
}
