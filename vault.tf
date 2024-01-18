provider "vault" {
  address = var.gitlab_vault_server_url
}

resource "vault_jwt_auth_backend" "gitlab" {
  description  = "JWT auth backend for Gitlab-CI pipeline"
  path         = "gitlab_jwt"
  jwks_url     = "https://gitlab.com/-/jwks"
  bound_issuer = "gitlab.com"
  default_role = "generic"
  tune {
    listing_visibility = "unauth"
    default_lease_ttl  = var.gitlab_default_lease_ttl
    max_lease_ttl      = var.gitlab_max_lease_ttl
    token_type         = var.gitlab_token_type
  }
}

resource "vault_policy" "pipeline-policy" {
  name = "pipeline-policy"

  policy = <<EOT
path "kv/test" {
  capabilities = ["read"]
}

path "kv/data/test" {
  capabilities = ["read"]
}
EOT
}

resource "vault_jwt_auth_backend_role" "pipeline" {
  backend   = vault_jwt_auth_backend.gitlab.path
  role_type = "jwt"

  role_name      = "app-pipeline"
  token_policies = ["default", "pipeline-policy"]

  bound_claims = {
    project_id = data.gitlab_project.vault.id
    ref        = "main"
    ref_type   = "branch"
  }

  user_claim = "environment"

  claim_mappings = {
    "project_id"            = "project_id"
    "namespace_id"          = "namespace_id"
    "namespace_path"        = "namespace_path"
    "project_id"            = "project_id"
    "project_path"          = "project_path"
    "user_id"               = "user_id"
    "user_login"            = "user_login"
    "user_email"            = "user_email"
    "pipeline_id"           = "pipeline_id"
    "pipeline_source"       = "pipeline_source"
    "job_id"                = "job_id"
    "ref"                   = "ref"
    "ref_type"              = "ref_type"
    "ref_protected"         = "ref_protected"
    "environment"           = "environment"
    "environment_protected" = "environment_protected"
  }
}

resource "vault_mount" "secret-mount" {
  path        = "kv"
  type        = "kv-v2"
  description = "KV Secrets engine"
}

resource "vault_generic_secret" "lob-secret" {
  path = "kv/test"

  data_json = <<EOT
{
    "foo": "This is my super secure secret!"
}
EOT

  depends_on = [vault_mount.secret-mount]
}
