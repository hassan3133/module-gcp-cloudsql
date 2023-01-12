#----------------------------------------------------------------------------
# inputs - module parameters
#----------------------------------------------------------------------------
variable "database_version" {
  description = "The database version to use e.g. SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB. SQLSERVER_2019_STANDARD, SQLSERVER_2019_ENTERPRISE, SQLSERVER_2019_EXPRESS, SQLSERVER_2019_WEB1"
  type        = string
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = null
}

variable "env" {
  description = "The environment name"
  type        = string
}

variable "name" {
  description = "Name of the database"
  type        = string
}

variable "network_type" {
  # refer to env_to_network_project variable in https://github.com/pcln/terraform-gcp-varlib
  description = "used to identify the network"
  type        = string
  default     = "net"
}

variable "project" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used"
  type        = string
}

variable "region" {
  description = "The region of the Cloud SQL resources"
  type        = string
  default     = "us-east4"
}

variable "settings" {
  description = "Allows you to configure various settings of that instances."
  type        = any
  default     = {}
}

variable "team" {
  description = "Team name used to determine of billing labels for the secrets"
  type        = string
}

variable "timeouts" {
  description = "Allows you to configure various timeouts settings of that instances."
  type        = any
  default     = {}
}
