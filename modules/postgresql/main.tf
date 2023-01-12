#----------------------------------------------------------------------------
# locals
#----------------------------------------------------------------------------

locals {
  network_project = module.gcp_varlib.env_to_network_project[var.network_type][var.env]
  network_name    = module.gcp_varlib.network_project_to_network[local.network_project]
  datacenter      = module.gcp_varlib.region_to_datacenter[var.region]
  default_labels = {
    managed_by = "terraform",
  }
  billing_labels = module.gcp_varlib.team_cloudcost_labels[var.team]

  backup_configs = length(keys(lookup(var.settings, "backup_configuration", {}))) > 0 ? merge(
    { enabled = true, start_time = "02:55" },
    var.settings["backup_configuration"]
  ) : { enabled = true, start_time = "02:55" }

  default_db_flags = [
    { name = "log_checkpoints", value = "on" },
    { name = "log_min_duration_statement", value = "-1" },
    { name = "log_connections", value = "on" },
    { name = "log_lock_waits", value = "on" },
    { name = "log_disconnections", value = "on" },
    { name = "log_min_error_statement", value = "error" },
    { name = "log_temp_files", value = "0" },
  ]

  database_flags_concat = concat(local.default_db_flags, lookup(var.settings, "database_flags", []))
  database_flags        = values(zipmap(local.database_flags_concat.*.name, local.database_flags_concat))
}


#----------------------------------------------------------------------------
# Resources Instances
#----------------------------------------------------------------------------

resource "google_sql_database_instance" "default" {

  provider            = google-beta
  project             = var.project
  name                = var.primary_custom_name != null ? var.primary_custom_name : format("%s-%s-%s", local.datacenter, var.name, var.env)
  database_version    = var.database_version
  region              = var.region
  encryption_key_name = var.encryption_key_name
  deletion_protection = var.deletion_protection

  lifecycle {
    ignore_changes = [
      settings[0].disk_size,
    ]
  }

  dynamic "settings" {

    for_each = length(keys(var.settings)) > 0 ? [1] : []
    content {
      tier              = lookup(var.settings, "tier", null)
      activation_policy = lookup(var.settings, "activation_policy", "ALWAYS")
      availability_type = lookup(var.settings, "availability_type", null)
      disk_autoresize   = lookup(var.settings, "disk_autoresize", true)
      disk_size         = lookup(var.settings, "disk_size", 10)       # 10 GB is default
      disk_type         = lookup(var.settings, "disk_type", "PD_SSD") # Default is PD_SSD or PD_HDD
      pricing_plan      = lookup(var.settings, "pricing_plan", "PER_USE")
      user_labels       = merge(local.default_labels, merge(local.billing_labels, lookup(var.settings, "user_labels", null)))

      dynamic "database_flags" {
        for_each = length(local.database_flags) > 0 ? local.database_flags : []
        content {
          name  = lookup(database_flags.value, "name", null)
          value = lookup(database_flags.value, "value", null)
        }
      }
      dynamic "backup_configuration" {
        for_each = length(keys(local.backup_configs)) > 0 ? [1] : []
        content {
          binary_log_enabled             = false
          enabled                        = lookup(local.backup_configs, "enabled", null)
          start_time                     = lookup(local.backup_configs, "start_time", null)
          location                       = lookup(local.backup_configs, "location", null)
          point_in_time_recovery_enabled = lookup(local.backup_configs, "point_in_time_recovery_enabled", false)
        }
      }
      dynamic "ip_configuration" {
        for_each = length(keys(lookup(var.settings, "ip_configuration", {}))) > 0 ? [1] : [0]
        content {
          ipv4_enabled    = lookup(var.settings["ip_configuration"], "ipv4_enabled", null)
          private_network = lookup(var.settings["ip_configuration"], "private_network", data.google_compute_network.default.self_link)
          require_ssl     = lookup(var.settings["ip_configuration"], "require_ssl", false)

          dynamic "authorized_networks" {
            for_each = length(lookup(var.settings["ip_configuration"], "authorized_networks", [])) > 0 ? lookup(var.settings["ip_configuration"], "authorized_networks", []) : []
            content {
              name            = lookup(authorized_networks.value, "name", null)
              expiration_time = lookup(authorized_networks.value, "expiration_time", null)
              value           = lookup(authorized_networks.value, "value", null)
            }
          }
        }
      }
      dynamic "location_preference" {
        for_each = length(keys(lookup(var.settings, "location_preference", {}))) > 0 ? [1] : []
        content {
          follow_gae_application = lookup(var.settings["location_preference"], "follow_gae_application", null)
          zone                   = lookup(var.settings["location_preference"], "zone", null)
        }
      }
      dynamic "maintenance_window" {
        for_each = length(keys(lookup(var.settings, "maintenance_window", {}))) > 0 ? [1] : []
        content {
          day          = lookup(var.settings["maintenance_window"], "day", null)
          hour         = lookup(var.settings["maintenance_window"], "hour", null)
          update_track = lookup(var.settings["maintenance_window"], "update_track", null)
        }
      }
      dynamic "insights_config" {
        for_each = length(keys(lookup(var.settings, "insights_config", {}))) > 0 ? [1] : []
        content {
          query_insights_enabled  = lookup(var.settings["insights_config"], "query_insights_enabled", null)
          query_string_length     = lookup(var.settings["insights_config"], "query_string_length", null)
          record_application_tags = lookup(var.settings["insights_config"], "record_application_tags", null)
          record_client_address   = lookup(var.settings["insights_config"], "record_client_address", null)
        }
      }
    }
  }
  dynamic "timeouts" {
    for_each = length(keys(var.timeouts)) > 0 ? [1] : []
    content {
      create = lookup(var.timeouts, "create", "10m")
      update = lookup(var.timeouts, "update", "10m")
      delete = lookup(var.timeouts, "delete", "10m")
    }
  }

}
#----------------------------------------------------------------------------
#  Data
#----------------------------------------------------------------------------

data "google_compute_network" "default" {
  name    = local.network_name
  project = local.network_project
}

#----------------------------------------------------------------------------
