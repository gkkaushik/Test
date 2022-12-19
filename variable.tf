variable "project_id" {
  description = "GCP Project ID, all resources will be created in this project."
}

variable "region" {
  description = "GCP Region, all resources will be created in this region."
  default     = "europe-west2"
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "env_name" {
  description = "Name of enviorment where kubernetes cluster deployed."
}

variable "primary_node_pool_name" {
  description = "Primary node pool name."
}

variable "secondary_node_pool_name" {
  description = "Secondary node pool name."
}

# cluster

variable "network" {
  description = "The self link of the VPC the cluster will be on."
}

variable "subnetwork" {
  description = "The self link of the subnet the cluster will be on, nodes will be created in this range."
}

variable "master_ipv4_cidr_block" {
  description = "A /28 CIDR range for the control plane, Google will peer this with your VPC."
}

variable "primary_pod_ip_range_name" {
  description = "The name of the alias range that the pods will be created in."
 
}

variable "secondary_pod_ip_range_name" {
  description = "The name of the alias range for the secondary pool."

}

variable "services_ip_range_name" {
  description = "The name of the alias range that the services will be created in."
  
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}


# node pool
variable "initial_node_count" {
  description = "Initial number of nodes to create per zone at point of creating the node pool."
  default     = 1
}

variable "min_node_count" {
  description = "Minimum number of nodes per zone the cluster can scale to."
  default     = 0
}

variable "max_node_count" {
  description = "Maximum number of nodes per zone the cluster can scale to."
  default     = 3
}

variable "node_pool_auto_repair" {
  description = "Enables healthchecks to monitor the nodes, GKE will automatically destory and replace nodes that fail these checks."
  default     = true
}

variable "node_pool_auto_upgrade" {
  description = "Enables node pool to be upgraded to GKE version when the control plane is upgraded."
  default     = true
}

variable "node_pool_max_surge" {
  description = "Maximum number of extra nodes allowed during upgrades."
  default     = 1
}

variable "node_pool_max_unavailable" {
  description = "Amount of nodes allowed to be taken offline during upgrades."
  default     = 0
}

variable "primary_nodepool_machine_type" {
  default = "n1-standard-1"
}

variable "secondary_nodepool_machine_type" {
  default = "n1-standard-1"
}

variable "image_type" {
  default = "COS_CONTAINERD"
}

variable "node_pool_oauth_scopes" 
  default = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

variable "service_account" {
  description = "Name of service account the nodes will run as."
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = "STABLE"

