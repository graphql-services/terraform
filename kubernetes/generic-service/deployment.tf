resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = "${var.project}-${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      project = "${var.project}"
      app     = "${var.name}"
    }

    template {
      metadata {
        labels= {
          project = "${var.project}"
          app     = "${var.name}"
        }
      }

      spec {
        container {
          name    = "app"
          image   = "${var.image}"
          command = "${var.command}"

          port {
            container_port = 80
          }

          env = "${var.env}"

          liveness_probe  = "${var.liveness_probe}"
          readiness_probe = "${var.readiness_probe}"

          resources {
            requests {
              cpu    = "0.1"
              memory = "256Mi"
            }
          }
        }

        image_pull_secrets {
          name = "gitlab-registry"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      "spec.0.template.0.spec.0.container.0.image",
    ]
  }
}
