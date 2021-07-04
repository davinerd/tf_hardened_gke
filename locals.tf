locals {
  local_authorized_network = [
    {
      cidr_block   = "${chomp(data.http.my_public_ip.body)}/32",
      display_name = "My public IP"
    }
  ]

  # THE FOLLOWING CODE IS REPORTED HERE JUST AS REFERENCE
  # Check if we passed down a map or just a list of IPs
  # master_networks_key_exists = contains(keys(var.master_authorized_networks), "cidr_block") <- doesn't work since var.master_authorized_networks must be known before apply
  # global_master_networks = local.master_networks_key_exists ? var.master_authorized_networks : [for ip in var.master_authorized_networks: tomap({cidr_block = ip, display_name = "Custom IP"})]
  # Build the actual authorized networks list
  # master_authorized_networks = var.master_authorized_networks == [] ? local.local_authorized_network : local.global_master_networks

  master_authorized_networks = length(var.master_authorized_networks) == 0 ? local.local_authorized_network : var.master_authorized_networks

  default_node_pools_labels = {
    all = {
      (var.node_pools_name) = true
    }
  }

  node_pools_labels = var.node_pools_labels != {} ? var.node_pools_labels : local.default_node_pools_labels

  default_node_pools_tains = {
    all = [{
      key    = var.node_pools_name
      value  = true
      effect = "PREFER_NO_SCHEDULE"
    }]
  }

  node_pools_taints = var.node_pools_taints != {} ? var.node_pools_taints : local.default_node_pools_tains

  default_node_pools = {
      name               = var.node_pools_name
      machine_type       = var.machine_type
      node_locations     = join(",", var.zones)
      min_count          = var.node_min_count
      max_count          = var.node_max_count
      local_ssd_count    = 0
      disk_size_gb       = var.disk_size_gb
      disk_type          = var.disk_type
      image_type         = var.image_type
      auto_repair        = var.node_auto_repair
      auto_upgrade       = var.node_auto_upgrade
      preemptible        = var.node_preemptible
      initial_node_count = var.initial_node_count
    }

  node_pools = [for k in var.node_pools: merge(local.default_node_pools, k)]

  resource_labels = merge(var.cluster_resource_labels, { name = var.name })
}
