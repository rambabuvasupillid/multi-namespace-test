# To read transit credentials
path "transit/keys/db_rsa_key" {
  capabilities = [ "read", "list" ]
}
#  # Manage namespaces
# path "ci/*" {
#    capabilities = ["create", "read", "update", "delete", "list"]
#}
