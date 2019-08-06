resource "kubernetes_ingress" "api" {
  metadata {
    name      = "api-${var.environment}"
    namespace = "${var.namespace}"

    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      "nginx.ingress.kubernetes.io/use-regex"      = "true"

      "certmanager.k8s.io/cluster-issuer" = "letsencrypt"

      # "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/enable-cors" = "true"

      # "nginx.ingress.kubernetes.io/cors-allow-methods"     = "PUT, GET, POST, OPTIONS"
      # "nginx.ingress.kubernetes.io/cors-allow-origin"      = "*"
      # "nginx.ingress.kubernetes.io/cors-allow-credentials" = "true"
    }
  }

  spec {
    rule {
      host = "${var.hostname}"

      http {
        path {
          path = "/(.*)"

          backend {
            service_name = "${var.name}-app-${var.environment}"
            service_port = 80
          }
        }

        path {
          path = "/(graphql)"

          backend {
            service_name = "${var.name}-gateway-${var.environment}"
            service_port = 80
          }
        }
      }
    }

    tls {
      hosts       = ["${var.hostname}"]
      secret_name = "${var.name}-${var.environment}-cert"
    }
  }
}
