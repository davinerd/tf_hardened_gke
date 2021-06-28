# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  #load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

# to use this module, the service account needs the following roles
# - compute viewer
# - compute security admin
# - compute network admin
# - kubernetes engine cluster admin
# - kubernetes engine developer
# - service account admin
# - service account user
# - iam project admin

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version                    = "15.0.0"
  project_id                 = var.project_id
  name                       = var.name
  region                     = var.region
  regional                   = var.regional
  zones                      = var.zones
  network                    = google_compute_network.network.name
  subnetwork                 = google_compute_subnetwork.subnetwork.name
  http_load_balancing        = var.ingress_nginx_enabled ? false : var.http_load_balancing
  ip_range_pods              = google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name
  ip_range_services          = google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name
  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
  network_policy             = var.network_policy
  enable_private_endpoint    = var.enable_private_endpoint
  enable_private_nodes       = var.private
  master_ipv4_cidr_block     = var.master_ipv4_block
  basic_auth_password        = var.basic_auth_password
  basic_auth_username        = var.basic_auth_username
  cluster_autoscaling        = var.cluster_autoscaling
  enable_pod_security_policy = var.enable_pod_security_policy

  database_encryption     = var.database_encryption
  network_policy_provider = var.network_policy_provider
  enable_shielded_nodes   = var.enable_shielded_nodes

  authenticator_security_group = var.authenticator_security_group
  network_project_id           = var.network_project_id

  node_metadata = var.node_metadata

  release_channel = var.release_channel

  registry_project_ids = var.registry_project_ids

  firewall_inbound_ports = var.firewall_inbound_ports


  firewall_priority = var.firewall_priority

  gcloud_upgrade = var.gcloud_upgrade

  grant_registry_access = var.grant_registry_access

  impersonate_service_account = var.impersonate_service_account
  identity_namespace          = var.identity_namespace

  ip_masq_link_local = var.ip_masq_link_local

  ip_masq_resync_interval = var.ip_masq_resync_interval

  issue_client_certificate = var.issue_client_certificate

  kubernetes_version = var.kubernetes_version

  logging_service = var.logging_service

  maintenance_start_time = var.maintenance_start_time

  monitoring_service = var.monitoring_service

  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling

  enable_resource_consumption_export = var.enable_resource_consumption_export

  enable_network_egress_export = var.enable_network_egress_export
  enable_binary_authorization  = var.enable_binary_authorization

  add_cluster_firewall_rules = var.add_cluster_firewall_rules

  remove_default_node_pool = var.remove_default_node_pool

  cluster_resource_labels = local.resource_labels

  configure_ip_masq = var.configure_ip_masq

  default_max_pods_per_node = var.default_max_pods_per_node

  deploy_using_private_endpoint = var.deploy_using_private_endpoint

  disable_legacy_metadata_endpoints = var.disable_legacy_metadata_endpoints

  create_service_account = var.create_service_account

  service_account = var.service_account

  master_authorized_networks = var.enable_private_endpoint ? [] : local.master_authorized_networks

  node_pools = local.node_pools

  node_pools_oauth_scopes = {
    all = var.oauth_scopes
  }

  node_pools_labels = local.node_pools_labels

  node_pools_taints = local.node_pools_taints

  node_pools_tags = {
    all = [var.node_pools_name]
  }
}
