# terraform_vault_gitlab_auth
quick terraform job to configure Gitlab JWT Auth


## Pre requirements
to use this terraform code you will need access  to gitlab(the free,gtilab.com version is fine) and Vault (the OSS version is fine but I used HCP Vault).

you will need to generate a gitlab [OAuth2 token or project/personal access token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)


### terraform provider
this code needs that the Vault and JWT provider access be set as enviroment variables:
```bash
export GITLAB_TOKEN=<GITLAB_TOKEN>
export VAULT_TOKEN=<VAULT_TOKEN>
```

### terraform variables
this project has the following mandatory variables that need to be provided using `tfvars` file:

```text
# Namespaced path to the Gitlab project where the JWT integration with Vault has to be setup
gitlab_project_path = "srinat999/gitlab-vault-integration"
# URL where the vault server can be reached
gitlab_vault_server_url = "https://localhost:8200"
# Vault Namespace to be used
gitlab_vault_server_namespace = "admin"
```

## running the code

```bash
terraform init
terraform plan
terraform apply
```
There is also a sample `.gitlab-ci.yml` which can be be used to the test the integration.


## Entities & JWT Auth
JWT Auth Method creates entities based on the *user_claim* configured at the Vault JWT Auth Method role; These can be a field from the [JWT token itself](https://docs.gitlab.com/ee/ci/examples/authenticating-with-hashicorp-vault/index.html#how-it-works)

depending on how the user_claim is configured, it is also possible to use the bound_claim to specify the match paramaters that allow authentication.