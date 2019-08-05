# resource "mysql_database" "id" {
#   name              = "novacloud_auth_id"
#   default_collation = "utf8_czech_ci"
# }
resource "postgresql_database" "id" {
  name = "${var.name}_auth_id"
}

resource "kubernetes_service" "id" {
  metadata {
    name      = "id${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      stack = "microid"
      app   = "id${var.namesuffix}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "id" {
  metadata {
    name      = "id${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        stack = "microid"
        app   = "id${var.namesuffix}"
      }
    }

    template {
      metadata {
        labels {
          stack = "microid"
          app   = "id${var.namesuffix}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "graphql/id"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          env {
            name = "DATABASE_URL"

            value_from {
              secret_key_ref {
                name = "microid${var.namesuffix}"
                key  = "idDatabaseURL"
              }
            }
          }

          env {
            name  = "OAUTH_URL"
            value = "http://oauth${var.namesuffix}/graphql"
          }

          env {
            name  = "IDP_URL"
            value = "http://idp${var.namesuffix}/graphql"
          }

          env {
            name  = "EVENT_TRANSPORT_URL"
            value = "http://mail-notifications${var.namesuffix}"
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
      }
    }
  }
}
