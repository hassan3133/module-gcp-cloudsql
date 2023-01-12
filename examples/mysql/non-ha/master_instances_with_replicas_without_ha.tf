locals {

  database_flags = [
    { name = "local_infile", value = "off" },
    { name = "log_bin_trust_function_creators", value = "on" },
  ]
  disk_size = 50
}

module "gp-master" {


  source = "git::https://github.com/pcln/terraform-gcp-cloudsql.git//modules/mysql"

  name                = "gpmaster"
  database_version    = "MYSQL_8_0"
  team                = "data_eng"
  deletion_protection = true

  settings = {
    tier                 = "db-n1-standard-4"
    disk_size            = local.disk_size
    availability_type    = "ZONAL"
    ip_configuration     = { ipv4_enabled = false }
    backup_configuration = { enabled = true, binary_log_enabled = true, start_time = "20:55" }
    location_preference  = { zone = "us-east4-a" }
    database_flags       = local.database_flags
  }

  read_replicas = [

    { name                         = "0"
      region                       = var.region
      deletion_protection_replicas = true
      settings = {
        tier                = "db-n1-standard-4"
        disk_size           = local.disk_size
        availability_type   = "ZONAL"
        ip_configuration    = { ipv4_enabled = false }
        location_preference = { zone = "us-east4-b" }
        database_flags      = local.database_flags
      }
    },
    { name                         = "1"
      region                       = var.region
      deletion_protection_replicas = true
      settings = {
        tier                = "db-n1-standard-4"
        disk_size           = local.disk_size
        availability_type   = "ZONAL"
        ip_configuration    = { ipv4_enabled = false }
        location_preference = { zone = "us-east4-c" }
        database_flags      = local.database_flags
      }
    },
    { name                         = "2"
      region                       = "northamerica-northeast1"
      deletion_protection_replicas = true
      settings = {
        tier                = "db-n1-standard-4"
        disk_size           = local.disk_size
        availability_type   = "ZONAL"
        ip_configuration    = { ipv4_enabled = false }
        location_preference = { zone = "northamerica-northeast1-a" }
        database_flags      = local.database_flags
      }
    },
  ]

  # pass through
  project = var.project
  region  = var.region
  env     = var.env

}
