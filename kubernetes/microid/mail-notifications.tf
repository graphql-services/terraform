resource "kubernetes_service" "mail-notifications" {
  metadata {
    name      = "mail-notifications${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      stack = "microid"
      app   = "mail-notifications${var.namesuffix}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "mail-notifications" {
  metadata {
    name      = "mail-notifications${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        stack = "microid"
        app   = "mail-notifications${var.namesuffix}"
      }
    }

    template {
      metadata {
        labels {
          stack = "microid"
          app   = "mail-notifications${var.namesuffix}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "graphql/id-mail-notifications"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          env {
            name  = "SMTP_URL"
            value = "${var.smtp_url}"
          }

          env {
            name  = "SMTP_SENDER"
            value = "${var.smtp_sender}"
          }

          env {
            name  = "PROJECT_NAME"
            value = "MuniProjects"
          }

          env {
            name  = "PROJECT_HOSTNAME"
            value = "https://id.muniprojects.com"
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
            tcp_socket {
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "5"
            period_seconds        = "10"
          }

          readiness_probe {
            tcp_socket {
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "5"
            period_seconds        = "10"
          }
        }
      }
    }
  }
}
