locals {
  master_authorized_networks = [
      {
          cidr_block = "${chomp(data.http.my_public_ip.body)}/32",
          display_name = "My public IP"
      }
  ]

  resource_labels = merge(var.cluster_resource_labels, {name = var.name})
}