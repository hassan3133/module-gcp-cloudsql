locals {

  gres_database_flags = [
    { name = "log_checkpoints", value = "off" },
    { name = "log_connections", value = "on" },
  ]
  gress_disk_size = 100
}

module "gp-master" {

  source = "git::https://github.com/pcln/terraform-gcp-cloudsql.git//modules/mysql"

  name                = "gpmstrgress"
  database_version    = "POSTGRES_13"
  team                = "data_eng"
  deletion_protection = true

  settings = {
    tier                 = "db-custom-1-3840"
    disk_size            = local.gress_disk_size
    availability_type    = "REGIONAL"
    ip_configuration     = { ipv4_enabled = false }
    backup_configuration = { enabled = true, start_time = "20:55" }
    location_preference  = { zone = "us-east4-a" }
    database_flags       = local.gres_database_flags
  }

  read_replicas = [
    {
      name                         = "0"
      region                       = var.region
      deletion_protection_replicas = true
      settings = {
        tier                = "db-custom-1-3840"
        disk_size           = local.gress_disk_size
        availability_type   = "ZONAL"
        ip_configuration    = { ipv4_enabled = false }
        location_preference = { zone = "us-east4-b" }
        database_flags      = local.gres_database_flags
      }
    },
    {
      name                         = "1"
      region                       = var.region
      deletion_protection_replicas = true
      settings = {
        tier                = "db-custom-1-3840"
        disk_size           = local.gress_disk_size
        availability_type   = "ZONAL"
        ip_configuration    = { ipv4_enabled = false }
        location_preference = { zone = "us-east4-c" }
        database_flags      = local.gres_database_flags
      }
    },
    {
      name                         = "2"
      region                       = "northamerica-northeast1"
      deletion_protection_replicas = true
      settings = {
        tier                = "db-custom-1-3840"
        disk_size           = local.gress_disk_size
        availability_type   = "ZONAL"
        ip_configuration    = { ipv4_enabled = false }
        location_preference = { zone = "northamerica-northeast1-a" }
        database_flags      = local.gres_database_flags
      }
    },
  ]

  # pass through
  project = var.project
  region  = var.region
  env     = var.env
}
