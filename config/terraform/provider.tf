# This is where you put your provider declaration.
#
# If you end up adding a cloud provider, you should also configure a terraspace_plugin_* gem
# in the Terraspace project Gemfile and run bundle.
#
# See: https://terraspace.cloud/docs/plugins/

provider "abbey" {
  # Configuration options
}

provider "snowflake" {
account   = var.account
username  = var.username
password  = var.password
}
