resource "kubernetes_secret" "main" {
  metadata {
    name      = "${var.name}-${var.environment}"
    namespace = "${var.namespace}"
  }

  data = {
    databaseURL = "${var.database_url}/${var.name}-orm-${var.environment}"
  }

  type = "Opaque"
}
