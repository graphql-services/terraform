resource "kubernetes_service" "service" {
  metadata {
    name      = "${var.project}-${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    selector = {
      project = "${var.project}"
      app     = "${var.name}"
    }

    port = "${var.service_ports}"
  }
}
