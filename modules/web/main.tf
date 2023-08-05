provider "google" {
  region      = var.region
  credentials = var.credentials
}

provider "google-beta" {
  region      = var.region
  credentials = var.credentials
}

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.1.0"

  name              = "example-${var.environment}"
  random_project_id = "true"
  org_id            = var.organization_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account
  activate_apis = [
    "appengine.googleapis.com",
    "iam.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com",
    "bigquery.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

resource "google_service_account" "backend" {
  project    = module.project.project_id
  account_id = "backend"
}

resource "google_project_iam_member" "backend_roles" {
  count   = length(local.backend_roles)
  project = module.project.project_id
  role    = local.backend_roles[count.index]
  member  = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_secret_manager_secret_iam_member" "backend_secret_access_roles" {
  count     = length(var.env_secret_variables)
  project   = module.project.project_id
  provider  = google-beta
  secret_id = var.env_secret_variables[count.index].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_bigquery_dataset" "web_datasets" {
  count         = length(local.backend_datasets)
  project       = module.project.project_id
  dataset_id    = local.backend_datasets[count.index].dataset_id
  friendly_name = local.backend_datasets[count.index].friendly_name
  description   = local.backend_datasets[count.index].description
  location      = var.region
}

resource "google_logging_project_sink" "sink_logs" {
  count                  = length(local.backend_datasets)
  project                = module.project.project_id
  name                   = "${local.backend_datasets[count.index].dataset_id}_synk"
  destination            = "bigquery.googleapis.com/projects/${module.project.project_id}/datasets/${local.backend_datasets[count.index].dataset_id}"
  filter                 = "log_name=projects/${module.project.project_id}/logs/${local.backend_datasets[count.index].dataset_id}"
  unique_writer_identity = true
}

resource "google_project_iam_member" "log_writers" {
  count   = length(local.backend_datasets)
  project = module.project.project_id
  role    = "roles/bigquery.dataEditor"
  member  = google_logging_project_sink.sink_logs[count.index].writer_identity
}

resource "google_app_engine_application" "app" {
  project  = module.project.project_id
  location_id = var.region
}

resource "google_cloudbuild_trigger" "web_branch_build" {
  project  = module.project.project_id
  name     = "example"
  filename = "cloudbuild.yaml"

  trigger_template {
    branch_name = var.build_branch
    repo_name   = "github_holyshared_example-app"
  }

  substitutions = {
    _PORT                       = "8080"
    _DOMAIN_NAME                = var.domain
    _BUILD_ENV                  = var.environment
    _NODE_ENV                   = "production"
  }
}

resource "google_project_iam_member" "cloud_build_roles" {
  count = length(local.cloud_build_roles)
  project = module.project.project_id
  role    = local.cloud_build_roles[count.index]
  member  = "serviceAccount:${module.project.project_number}@cloudbuild.gserviceaccount.com"

  depends_on = [
    module.project
  ]
}
