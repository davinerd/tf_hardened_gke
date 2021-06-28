name   = "staging-europe-west4"
region = "europe-west4"
zones  = ["europe-west4-a", "europe-west4-b"]

# Multi zone cluster, node counts are per zone
node_pools_details = [
  {
    name               = "primary-pool"
    machine_type       = "c2-standard-8"
    min_count          = 1
    max_count          = 3
    local_ssd_count    = 0
    disk_size_gb       = 100
    initial_node_count = 1
  },
  {
    name               = "secondary-pool"
    machine_type       = "custom-8-32768"
    min_count          = 1
    max_count          = 20
    local_ssd_count    = 0
    disk_size_gb       = 200
    initial_node_count = 5
  }
]

node_pools_labels = {
  primary-pool = {
    jobs = "cpu"
  }
}

node_pools_taints = {
  all = []

  primary-pool = [
    {
      key    = "jobs"
      value  = "cpu"
      effect = "PREFER_NO_SCHEDULE"
    }
  ]

  secondary-pool = [
    {
      key    = "nvidia.com/gpu"
      value  = "present"
      effect = "PREFER_NO_SCHEDULE"
    }
  ]
}

# TODO
# tags
