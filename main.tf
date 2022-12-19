# Enable Compute Engine/Container APIs
resource "google_project_service" "project" {
  project = var.project_id

  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com"
  ])

  service            = each.key
  disable_on_destroy = false
}

data "google_compute_network" "network" {
  name    = var.network
  project = var.project_id
}

data "google_compute_network" "sub-network" {
  name    = var.subnetwork
  project = var.project_id
}

resource "google_container_cluster" "gke_cluster" {

  name                     = "${var.env_name}-cluster"
  location                 = var.region
  project                  = var.project_id
  network                  = data.google_compute_network.network.self_link
  subnetwork               = data.google_compute_network.sub-network.self_link
  remove_default_node_pool = true
  initial_node_count       = 1   
  enable_shielded_nodes    = true
  enable_intranode_visibility = true #Pod-Pod traffic enabled
  networking_mode          = "VPC_NATIVE"
  
  node_config {
    tags = ["private-cluster"] 
    metadata = {
      "block-project-ssh-keys"   = true,
      "disable-legacy-endpoints" = true
    }
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true 
    }
    service_account   = var.service_account_email
  }

  release_channel {
    channel = var.release_channel
  }

ip_allocation_policy {
    cluster_secondary_range_name  = var.primary_pod_ip_range_name
    services_secondary_range_name = var.services_ip_range_name
  }

  private_cluster_config {
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    enable_private_nodes    = true # All GKE nodes will be private and no public ips
    enable_private_endpoint = true # GKE master ip will be complete private
      }
    master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = var.cidr_block
          display_name = var.display_name
        },
      ]
    },
  ]
}
resource "google_container_node_pool" "primary_node_pool" {
  name               = var.primary_node_pool_name
  location           = var.region
  initial_node_count = var.initial_node_count
  cluster            = google_container_cluster.gke_cluster.name
  project            = var.project_id
  max_pods_per_node  = XXX

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = var.node_pool_auto_repair
    auto_upgrade = var.node_pool_auto_upgrade
  }

  upgrade_settings {
    max_surge       = var.node_pool_max_surge
    max_unavailable = var.node_pool_max_unavailable
  }

  node_config {
    image_type        = var.image_type
    machine_type      = var.primary_nodepool_machine_type
    oauth_scopes      = var.node_pool_oauth_scopes
   service_account = var.service_account_email
   labels = {
      "purpose" : "xyz" 
    }
    
    tags = [
      "primary-node-pool",
   
    ]
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true # GKE controls
    }
 
      
 

  depends_on = [
    google_container_cluster.gke_cluster
  ]
}

resource "google_container_node_pool" "secondary_node_pool" {
  name               = var.secondary_node_pool_name
  location           = var.region
  initial_node_count = var.initial_node_count
  cluster            = google_container_cluster.gke_cluster.name
  project            = var.project_id
  max_pods_per_node  = XXX
  
network_config {
    pod_range = var.secondary_pod_ip_range_name
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = var.node_pool_auto_repair
    auto_upgrade = var.node_pool_auto_upgrade
  }

  upgrade_settings {
    max_surge       = var.node_pool_max_surge
    max_unavailable = var.node_pool_max_unavailable
  }

  node_config {
    image_type      = var.image_type
    machine_type    = var.secondary_nodepool_machine_type
    oauth_scopes    = var.node_pool_oauth_scopes
    service_account = var.service_account_email

    labels = {
      "purpose" : "xyz" 
    }

    tags = [
      "Secondary-node-pool",
         ]

       shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true 
    }

  }

  depends_on = [
    google_container_cluster.gke_cluster
  ]
}


