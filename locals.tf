locals {
  master_authorized_networks = [
    {
      cidr_block   = "${chomp(data.http.my_public_ip.body)}/32",
      display_name = "My public IP"
    }
  ]

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
