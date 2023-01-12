# MySQL

## Single instance HA

Below example is single mysql instance with HA.
```
module "gp-instance" {
  source = "git::https://github.com/pcln/terraform-gcp-cloudsql.git//modules/mysql"

  name                = "gpinstance"
  database_version    = "MYSQL_8_0"
  team                = "data_eng"
  deletion_protection = true

  settings = {
    tier                = "db-n1-standard-4"
    disk_size           = 50
    availability_type   = "REGIONAL"
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
```

## Single instance non-HA
By switching the availability_type = "ZONAL" HA can be disabled ( refer to [**/examples/mysql**](../../examples/mysql) )


## Primary instance with replicas HA
Below example is master instance with replicas in different zone and diffrent region, with HA.
```
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
    availability_type    = "REGIONAL"
    ip_configuration     = { ipv4_enabled = false }
    backup_configuration = { enabled = true, binary_log_enabled = true, start_time = "20:55" }
    location_preference  = { zone = "us-east4-a" }
    database_flags       = local.database_flags
  }

  read_replicas = [
    {
      name                         = "0"
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
    {
      name                         = "1"
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
    {
      name                         = "2"
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
```

## Primary instance with replicas non-HA
By switching the availability_type = "ZONAL" HA can be disabled ( refer to [**/examples/mysql**](../../examples/mysql))

<!-- BEGIN_TF_DOCS -->
#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp_varlib"></a> [gcp_varlib](#module_gcp_varlib) | git::https://github.com/pcln/terraform-gcp-varlib.git//modules/gcp_varlib | n/a |

#### Resources

| Name | Type |
|------|------|
| [google-beta_google_sql_database_instance.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_sql_database_instance) | resource |
| [google-beta_google_sql_database_instance.replicas](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_sql_database_instance) | resource |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_version"></a> [database_version](#input_database_version) | The database version to use | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input_env) | The environment name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | Name of the environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | n/a | yes |
| <a name="input_team"></a> [team](#input_team) | Team name used to determine of billing labels for the secrets | `string` | n/a | yes |
| <a name="input_db_charset"></a> [db_charset](#input_db_charset) | The charset for the default database | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion_protection](#input_deletion_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_deletion_protection_replicas"></a> [deletion_protection_replicas](#input_deletion_protection_replicas) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_encryption_key_name"></a> [encryption_key_name](#input_encryption_key_name) | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input_labels) | The list of labels (key/value pairs) to be applied to instances in the cluster. | `map` | `{}` | no |
| <a name="input_network_type"></a> [network_type](#input_network_type) | used to identify the network | `string` | `"net"` | no |
| <a name="input_read_replicas"></a> [read_replicas](#input_read_replicas) | List of read replicas to create | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input_region) | The region of the Cloud SQL resources | `string` | `"us-east4"` | no |
| <a name="input_settings"></a> [settings](#input_settings) | Allows you to configure various settings of that instances. | `any` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input_timeouts) | Allows you to configure various timeouts settings of that instances. | `any` | `{}` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->
