#----------------------------------------------------------------------------
# inputs - module parameters
#----------------------------------------------------------------------------

variable "env" {
  description = "The environment name"
  type        = string
}

variable "labels" {
  description = "The list of labels (key/value pairs) to be applied to instances in the cluster."
  type        = map
  default     = {}
}

variable "name" {
  description = "Name of the environment"
  type        = string
}

variable "primary_custom_name" {
  description = "Custom name input for replica"
  type        = string
  default     = null
}

variable "database_version" {
  description = "The database version to use"
  type        = string
}

variable "region" {
  description = "The region of the Cloud SQL resources"
  type        = string
  default     = "us-east4"
}

variable "network_type" {
  // refer to env_to_network_project variable in https://github.com/pcln/terraform-gcp-varlib
  description = "used to identify the network"
  type        = string
  default     = "net"
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "settings" {
  description = "Allows you to configure various settings of that instances."
  type        = any
  default     = {}
}

variable "db_charset" {
  description = "The charset for the default database"
  type        = string
  default     = ""
}

variable "project" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used"
  type        = string
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


variable "deletion_protection_replicas" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "read_replicas" {
  description = "List of read replicas to create"
  type        = list(any)
  default     = []
}
