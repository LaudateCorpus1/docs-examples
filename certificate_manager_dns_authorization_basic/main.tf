resource "google_certificate_manager_dns_authorization" "default" {
  name        = "dns-auth-${local.name_suffix}"
  description = "The default dnss"
  domain      = "%{random_suffix}.hashicorptest.com"
}

output "record_name_to_insert" {
 value = google_certificate_manager_dns_authorization.default.dns_resource_record.0.name
}

output "record_type_to_insert" {
 value = google_certificate_manager_dns_authorization.default.dns_resource_record.0.type
}

output "record_data_to_insert" {
 value = google_certificate_manager_dns_authorization.default.dns_resource_record.0.data
}