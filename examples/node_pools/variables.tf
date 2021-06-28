variable "region" {
}

variable "zones" {
}

variable "name" {
}

variable "regional" {
  default = false
}

variable "monitoring_service" {
  default = "none"
}

variable "logging_service" {
  default = "none"
}

variable "outbound_access" {
  default = true
}

variable "ingress_nginx_enabled" {
  default = true
}

variable "grant_registry_access" {
  default = true
}

variable "authenticator_security_group" {
  default = "gke-security-groups@your_domain.com"
}

variable "image_type" {
  default = "COS"
}

variable "disk_type" {
  default = "pd-ssd"
}

variable "horizontal_pod_autoscaling" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon."
  default     = true
}

variable "node_auto_repair" {
  type    = bool
  default = true
}

variable "node_auto_upgrade" {
  default = true
}

variable "node_preemptible" {
  type    = bool
  default = false
}

variable "node_pools_details" {
  
}

variable "node_pools_taints" {
  
}

variable "node_pools_labels" {
  
}