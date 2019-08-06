resource "kubernetes_secret" "main" {
  metadata {
    name      = "microid${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  data = {
    idDatabaseURL    = "${var.database_url}/${var.database_table_prefix}id"
    idpDatabaseURL   = "${var.database_url}/${var.database_table_prefix}idp"
    oauthDatabaseURL = "${var.database_url}/${var.database_table_prefix}oauth"
  }

  type = "Opaque"
}
