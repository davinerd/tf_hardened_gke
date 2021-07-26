output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke.endpoint

}

output "get_credentials" {
  description = "Gcloud get-credentials command"
  value       = format("gcloud container clusters get-credentials --project %s --region %s %s", var.project_id, var.region, var.name)
}

output "master_ipv4_block" {
  value = var.master_ipv4_block
}

output "network" {
  description = "Network details"
  value = google_compute_network.network
}