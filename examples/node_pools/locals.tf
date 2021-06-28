locals {
  node_pools_default_values = {
    node_locations = join(",", var.zones)
    disk_type      = var.disk_type
    image_type     = var.image_type
    auto_repair    = var.node_auto_repair
    auto_upgrade   = var.node_auto_upgrade
    preemptible    = var.node_preemptible
  }
  node_pools = [for k in var.node_pools_details : merge(local.node_pools_default_values, k)]
}