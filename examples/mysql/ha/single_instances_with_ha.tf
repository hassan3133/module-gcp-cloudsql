module "gp-instance" {
  source = "git::https://github.com/pcln/terraform-gcp-cloudsql.git//modules/mysql"

  name                = "gpinstance"
  database_version    = "MYSQL_8_0"
  team                = "data_eng"
  deletion_protection = true

  settings = {
    tier                = "db-n1-standard-4"
    disk_size           = 50
    availability_type   = "REGIONAL" # REGIONAL will turn on HA
    ip_configuration    = { ipv4_enabled = false }
    location_preference = { zone = "us-east4-a" }
    database_flags = [
      { name = "local_infile", value = "off" },
      { name = "log_bin_trust_function_creators", value = "on" },
    ]
  }

  # pass through
  project = var.project
  region  = var.region
  env     = var.env

}
