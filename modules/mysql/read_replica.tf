#----------------------------------------------------------------------------
# locals
#----------------------------------------------------------------------------

locals {
  replica_network_project = module.gcp_varlib.env_to_network_project[var.network_type][var.env]
  replica_network_name    = module.gcp_varlib.network_project_to_network[local.replica_network_project]
  replica_datacenter      = module.gcp_varlib.region_to_datacenter[var.region]
  replica_default_labels = {
    managed_by = "terraform",
  }
  replica_billing_labels = module.gcp_varlib.team_cloudcost_labels[var.team]
  replicas = {
    for x in var.read_replicas : x.name => x
  }
}

#----------------------------------------------------------------------------
# Resources Instances
#----------------------------------------------------------------------------

resource "google_sql_database_instance" "replicas" {

  for_each             = local.replicas
  provider             = google-beta
  project              = var.project
  name                 = "${module.gcp_varlib.region_to_datacenter[each.value.region]}-${var.name}-${module.gcp_varlib.env_to_singlechar[var.env]}${each.value.name}"
  master_instance_name = google_sql_database_instance.default.name
  database_version     = var.database_version
  region               = length(lookup(each.value, "region", {})) > 0 ? each.value.region : var.region
  deletion_protection  = var.deletion_protection_replicas

  lifecycle {
    ignore_changes = [
      settings[0].disk_size,
      settings[0].maintenance_window,
    ]
  }
  dynamic "replica_configuration" {
    for_each = length(lookup(each.value, "replica_configuration", {})) > 0 ? [lookup(each.value, "replica_configuration", {})] : []
    content {
      ca_certificate            = lookup(replica_configuration.value, "ca_certificate", null)
      client_certificate        = lookup(replica_configuration.value, "client_certificate", null)
      client_key                = lookup(replica_configuration.value, "client_key", null)
      connect_retry_interval    = lookup(replica_configuration.value, "connect_retry_interval", null)
      dump_file_path            = lookup(replica_configuration.value, "dump_file_path", null)
      failover_target           = lookup(replica_configuration.value, "failover_target", false)
      master_heartbeat_period   = lookup(replica_configuration.value, "master_heartbeat_period", null)
      username                  = lookup(replica_configuration.value, "username", null)
      password                  = lookup(replica_configuration.value, "password", null)
      ssl_cipher                = lookup(replica_configuration.value, "ssl_cipher", null)
      verify_server_certificate = lookup(replica_configuration.value, "verify_server_certificate", null)
    }
  }

  dynamic "settings" {

    for_each = length(lookup(each.value, "settings", {})) > 0 ? [lookup(each.value, "settings", {})] : []
    content {
      tier              = lookup(settings.value, "tier", null)
      activation_policy = lookup(settings.value, "activation_policy", "ALWAYS")
      availability_type = lookup(settings.value, "availability_type", null)
      disk_autoresize   = lookup(settings.value, "disk_autoresize", true)
      disk_size         = lookup(settings.value, "disk_size", 10)       # 10 GB is default
      disk_type         = lookup(settings.value, "disk_type", "PD_SSD") # Default is PD_SSD or PD_HDD
      pricing_plan      = lookup(settings.value, "pricing_plan", "PER_USE")
      user_labels       = merge(local.default_labels, merge(local.billing_labels, lookup(settings.value, "user_labels", null)))

      dynamic "database_flags" {
        for_each = length(local.database_flags) > 0 ? local.database_flags : []
        content {
          name  = lookup(database_flags.value, "name", null)
          value = lookup(database_flags.value, "value", null)
        }
      }
      dynamic "ip_configuration" {
        for_each = length(lookup(each.value.settings, "ip_configuration", {})) > 0 ? [lookup(each.value.settings, "ip_configuration", {})] : []
        content {
          ipv4_enabled    = lookup(ip_configuration.value, "ipv4_enabled", null)
          private_network = lookup(ip_configuration.value, "private_network", data.google_compute_network.default.self_link)
          require_ssl     = lookup(ip_configuration.value, "require_ssl", false)

          dynamic "authorized_networks" {
            for_each = length(lookup(each.value.settings.ip_configuration, "authorized_networks", {})) > 0 ? [lookup(ip_configuration.value, "authorized_networks", {})] : []
            content {
              name            = lookup(authorized_networks.value, "name", null)
              expiration_time = lookup(authorized_networks.value, "expiration_time", null)
              value           = lookup(authorized_networks.value, "value", null)
            }
          }
        }
      }
      dynamic "location_preference" {
        for_each = length(lookup(each.value.settings, "location_preference", {})) > 0 ? [lookup(each.value.settings, "location_preference", {})] : []
        content {
          follow_gae_application = lookup(location_preference.value, "follow_gae_application", null)
          zone                   = lookup(location_preference.value, "zone", null)
        }
      }
      dynamic "maintenance_window" {
        for_each = length(lookup(each.value.settings, "maintenance_window", {})) > 0 ? [lookup(each.value.settings, "maintenance_window", {})] : []
        content {
          day          = lookup(maintenance_window.value, "day", null)
          hour         = lookup(maintenance_window.value, "hour", null)
          update_track = lookup(maintenance_window.value, "update_track", null)
        }
      }

    }
  }
  dynamic "timeouts" {
    for_each = length(lookup(each.value, "timeouts", {})) > 0 ? [lookup(each.value, "settings", {})] : []
    content {
      create = lookup(timeouts.value, "create", "10m")
      update = lookup(timeouts.value, "update", "10m")
      delete = lookup(timeouts.value, "delete", "10m")
    }
  }
  depends_on = [
    google_sql_database_instance.default,
  ]
}

#----------------------------------------------------------------------------
#  Data & Service
#----------------------------------------------------------------------------

data "google_compute_network" "replicas" {
  name    = local.replica_network_name
  project = local.replica_network_project
}

#----------------------------------------------------------------------------
