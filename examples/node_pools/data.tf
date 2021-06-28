data "google_project" "project" {
}

data "google_client_config" "default" {
  provider = google.tokengen
}

data "google_service_account_access_token" "sa" {
  provider               = google.tokengen
  target_service_account = "terraform-svc@your_project.iam.gserviceaccount.com"
  lifetime               = "1200s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}