project_id                      = "dev-gke"
network                         = "devnw"
region                          = "europe-west2"
subnetwork                      = "devsnw"
env_name                        = "dev"
primary_node_pool_name          = "dev-app"
secondary_node_pool_name        = "dev-egr"
master_ipv4_cidr_block          = "10.128.0.0/28"
service_account                 = "svc-gke-nodes"
release_channel                 = "STABLE"
min_node_count                  = 0
max_node_count                  = 3
primary_nodepool_machine_type   = "n1-standard-2"
secondary_nodepool_machine_type = "n1-standard-2"

master_authorized_networks = [
  {
    cidr_block   = "10.190.0.80/28"
    display_name = "devbastion"
  },
]
labels = {
  environment        = "dev"
  owner              = "platformteam"
 }
