locals {
  backend_roles = [
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/logging.logWriter"
  ]

  backend_datasets = [{
    dataset_id    = "request_log"
    friendly_name = "request_log"
    description   = "log of request"
  }]
}
