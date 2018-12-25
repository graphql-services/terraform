resource "kubernetes_ingress" "ingress" {
  count = "${length(var.hostname) > 0 ? 1 : 0}"

  metadata {
    name      = "${var.project}-${var.name}"
    namespace = "${var.namespace}"

    annotations {
      #   "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      #   "nginx.ingress.kubernetes.io/add-base-url"   = true
      "certmanager.k8s.io/cluster-issuer" = "letsencrypt"

      "nginx.ingress.kubernetes.io/ssl-redirect"    = "true"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "50m"
    }
  }

  spec {
    # backend {  #   service_name = "${var.name}-reporting"  #   service_port = 80  # }
    rule {
      host = "${var.hostname}"

      http {
        path {
          path_regex = "${var.path}"

          backend {
            service_name = "${var.project}-${var.name}"
            service_port = 80
          }
        }
      }
    }

    tls {
      hosts       = ["${var.hostname}"]
      secret_name = "${replace(var.hostname,".","-")}-cert"
    }
  }
}
