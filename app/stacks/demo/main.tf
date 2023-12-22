locals {
  account_name = ""
  repo_name = ""

  project_path = "github://${local.account_name}/${local.repo_name}"
  policies_path = "${local.project_path}/policies"
}

data "snowflake_database" "pii_database" {
  name = "REPLACE_ME"
}

data "snowflake_role" "pii_readonly_role" {
  name = "REPLACE_ME"
}

data "snowflake_users" "my_snowflake_user" {
  pattern = "REPLACE_ME"
}

resource "snowflake_table_grant" "pii_readonly__can_read__pii__table" {
  database_name     = data.snowflake_database.pii_database.name
  schema_name       = "REPLACE_ME"
  table_name        = "REPLACE_ME"
  privilege         = "SELECT"
  roles             = [data.snowflake_role.pii_readonly_role.name]
  with_grant_option = false
}

resource "abbey_grant_kit" "role__pii_readonly" {
  name = "PII READONLY role grant"
  description = <<-EOT
    Grants access to the PII READONLY Snowflake Role Grant.
    This Grant Kit uses a single-step Grant Workflow that requires only a single reviewer
    from a list of reviewers to approve access.
  EOT

  workflow = {
    steps = [
      {
        reviewers = {
          one_of = ["replace-me@example.com"]
        }
      }
    ]
  }

  output = {
    location = "${local.project_path}/access.tf"
    append = <<-EOT
      resource "snowflake_role_grants" "pii_readonly__{{ .user.username }}" {
        role_name = "${data.snowflake_role.pii_readonly_role.name}"
        users     = ["{{ .user.snowflake.username }}"]
      }
    EOT
  }
}
