resource "kubernetes_secret" "main" {
  metadata {
    name      = "microid${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  data {
    idDatabaseURL    = "${var.database_url}/${var.name}_auth_idp"
    idpDatabaseURL   = "${var.database_url}/${var.name}_auth_idp"
    oauthDatabaseURL = "${var.database_url}/${var.name}_auth_idp"
  }

  type = "Opaque"
}
