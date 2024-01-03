variable "gitlab_project_path" {
  type        = string
  description = "project id you want to enable JWT auth for"
}


variable "gitlab_default_lease_ttl" {
  type        = string
  description = "Default lease TTL for Vault tokens"
  default     = "12h"
}

variable "gitlab_max_lease_ttl" {
  type        = string
  description = "Maximum lease TTL for Vault tokens"
  default     = "768h"
}

variable "gitlab_token_type" {
  type        = string
  description = "Token type for Vault tokens"
  default     = "default-service"
}

variable "gitlab_vault_server_url" {
  type        = string
  description = "Public address of the Vault server"
}

variable "gitlab_vault_server_namespace" {
  type        = string
  description = "Namespace of the Vault server where the secrets are stored"
}