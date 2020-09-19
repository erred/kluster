resource "google_container_cluster" "cluster" {
  provider = google-beta

  name                     = var.cluster
  location                 = var.zone
  network                  = google_compute_network.cluster_network.self_link
  subnetwork               = google_compute_subnetwork.cluster_subnet.self_link
  remove_default_node_pool = true
  initial_node_count       = 1
  enable_shielded_nodes    = true

  addons_config {
    http_load_balancing {
      disabled = true
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "20:00"
    }
  }

  release_channel {
    channel = "RAPID"
  }

  workload_identity_config {
    identity_namespace = "${var.gcp_project}.svc.id.goog"
  }

  cluster_telemetry {
    type = "DISABLED"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster}"
  }
}

resource "google_container_node_pool" "stable" {
  provider = google-beta

  name       = "stable"
  location   = var.zone
  cluster    = google_container_cluster.cluster.name
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 40

    image_type = "COS_CONTAINERD"

    service_account = "kluster-compute@${var.gcp_project}.iam.gserviceaccount.com"
    # tags            = ["open"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      pool-type = "stable"
    }

    # taint {
    #   key    = "stable"
    #   value  = "true"
    #   effect = "NO_EXECUTE"
    # }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

# resource "google_container_node_pool" "preempt" {
#   provider = google-beta
#
#   name               = "preempt"
#   location           = var.zone
#   cluster            = google_container_cluster.cluster.name
#   initial_node_count = 3
#
#   # autoscaling {
#   #   min_node_count = 0
#   #   max_node_count = 3
#   # }
#
#   management {
#     auto_repair  = true
#     auto_upgrade = true
#   }
#
#   upgrade_settings {
#     max_surge       = 1
#     max_unavailable = 0
#   }
#
#   node_config {
#     machine_type = "e2-small"
#     disk_size_gb = 20
#
#     image_type = "COS_CONTAINERD"
#
#     service_account = "kluster-compute@${var.gcp_project}.iam.gserviceaccount.com"
#
#     metadata = {
#       disable-legacy-endpoints = "true"
#     }
#
#     labels = {
#       pool-type = "preempt"
#     }
#
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]
#   }
# }

# data "google_compute_instance_group" "stable" {
#   provider = google-beta
#
#   self_link = google_container_node_pool.stable.instance_group_urls.0
# }
#
# data "google_compute_instance" "stable" {
#   provider = google-beta
#
#   for_each = toset(data.google_compute_instance_group.stable.instances)
#
#   self_link = each.key
# }
