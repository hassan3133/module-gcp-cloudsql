module "gp-instance-postgresql" {
  source = "git::https://github.com/pcln/terraform-gcp-cloudsql.git//modules/mysql"

  name                = "gpgres"
  database_version    = "POSTGRES_13"
  team                = "data_eng"
  deletion_protection = true

  settings = {
    tier                = "db-custom-1-3840"
    disk_size           = 100
    availability_type   = "REGIONAL"
    ip_configuration    = { ipv4_enabled = false }
    location_preference = { zone = "us-east4-a" }
    database_flags = [
      { name = "log_checkpoints", value = "off" },
      { name = "log_connections", value = "on" },
      { name = "log_lock_waits", value = "on" },
    ]
  }

  # pass through
  project = var.project
  region  = var.region
  env     = var.env
}
