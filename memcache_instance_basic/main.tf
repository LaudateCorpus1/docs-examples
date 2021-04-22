// This example assumes this network already exists.
// The API creates a tenant network per network authorized for a
// Redis instance and that network is not deleted when the user-created
// network (authorized_network) is deleted, so this prevents issues
// with tenant network quota.
// If this network hasn't been created and you are using this example in your
// config, add an additional network resource or change
// this from "data"to "resource"
data "google_compute_network" "memcache_network" {
  provider = google-beta
  name = "test-network-${local.name_suffix}"
}

resource "google_compute_global_address" "service_range" {
  name          = "address-${local.name_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.memcache_network.id
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = data.google_compute_network.memcache_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}

resource "google_memcache_instance" "instance" {
  name = "test-instance-${local.name_suffix}"
  authorized_network = google_service_networking_connection.private_service_connection.network

  node_config {
    cpu_count      = 1
    memory_size_mb = 1024
  }
  node_count = 1
  memcache_version = "MEMCACHE_1_5"
}
