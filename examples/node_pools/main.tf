module "private_gke" {
  source = "github.com/davinerd/tf_hardened_gke"
  version = "0.2"

  project_id = data.google_project.project.project_id

  region = var.region

  zones = var.zones

  regional = var.regional

  name = var.name

  horizontal_pod_autoscaling = true

  monitoring_service = var.monitoring_service
  logging_service    = var.logging_service

  outbound_access = var.outbound_access

  ingress_nginx_enabled = var.ingress_nginx_enabled

  grant_registry_access = var.grant_registry_access

  authenticator_security_group = var.authenticator_security_group

  node_pools = local.node_pools
  node_pools_labels = var.node_pools_labels
  node_pools_taints = var.node_pools_taints
}
