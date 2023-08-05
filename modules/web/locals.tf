locals {
  backend_roles = [
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/logging.logWriter"
  ]

  cloud_build_roles = [
    "roles/secretmanager.secretAccessor",
    "roles/appengine.appAdmin",
    "roles/iam.serviceAccountUser"
  ]

  backend_datasets = [{
    dataset_id    = "request_log"
    friendly_name = "request_log"
    description   = "log of request"
  }]
}
