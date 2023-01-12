<!-- BEGIN_TF_DOCS -->
#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp_varlib"></a> [gcp_varlib](#module_gcp_varlib) | git::https://github.com/pcln/terraform-gcp-varlib.git//modules/gcp_varlib | n/a |

#### Resources

| Name | Type |
|------|------|
| [google-beta_google_sql_database_instance.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_sql_database_instance) | resource |
| [google_project_service.servicenetworking](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.sqladmin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.sqlcomponent](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [random_password.root](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_version"></a> [database_version](#input_database_version) | The database version to use e.g. SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB. SQLSERVER_2019_STANDARD, SQLSERVER_2019_ENTERPRISE, SQLSERVER_2019_EXPRESS, SQLSERVER_2019_WEB1 | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input_env) | The environment name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | Name of the database | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | n/a | yes |
| <a name="input_team"></a> [team](#input_team) | Team name used to determine of billing labels for the secrets | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion_protection](#input_deletion_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_encryption_key_name"></a> [encryption_key_name](#input_encryption_key_name) | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| <a name="input_network_type"></a> [network_type](#input_network_type) | used to identify the network | `string` | `"net"` | no |
| <a name="input_region"></a> [region](#input_region) | The region of the Cloud SQL resources | `string` | `"us-east4"` | no |
| <a name="input_settings"></a> [settings](#input_settings) | Allows you to configure various settings of that instances. | `any` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input_timeouts) | Allows you to configure various timeouts settings of that instances. | `any` | `{}` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->