resource "kubernetes_service" "app" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    selector = {
      app = "${var.name}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        app = "${var.name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.name}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "${var.initialImage}"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          env {
            name  = "REACT_APP_API_URL"
            value = "${var.apiURL}"
          }

          env {
            name  = "REACT_APP_TOKEN_URL"
            value = "${var.tokenURL}"
          }

          env {
            name  = "REACT_APP_CLIENT_ID"
            value = "default"
          }

          env {
            name  = "REACT_APP_CLIENT_SECRET"
            value = "default"
          }

          env {
            name  = "REACT_APP_FILE_UPLOAD_URL"
            value = "${var.fileUploadURL}"
          }

          resources {
            requests {
              cpu    = "0.01"
              memory = "8Mi"
            }

            limits {
              cpu    = "0.02"
              memory = "32Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/healthcheck"
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "5"
            period_seconds        = "10"
          }

          readiness_probe {
            http_get {
              path = "/healthcheck"
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "5"
            period_seconds        = "10"
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
      "spec[0].template[0].spec[0].container[0].image",
    ]
  }
}
