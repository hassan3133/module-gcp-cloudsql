module "mssql" {
  source = "git::https://github.com/pcln/terraform-gcp-cloudsql.git//modules/mssql"

  project             = var.project
  region              = var.region
  env                 = var.env
  name                = "${var.project}-mssql"
  database_version    = "SQLSERVER_2019_STANDARD"
  team                = "data_eng"
  deletion_protection = true

  settings = {
    tier                = "db-custom-2-3840"
    disk_size           = 10
    availability_type   = "REGIONAL"
    ip_configuration    = { ipv4_enabled = false }
    location_preference = { zone = "us-east4-a" }
  }
}
