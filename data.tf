data "kubernetes_service" "istio_ingressgateway" {
  metadata {
    name = "istio-ingressgateway"
    namespace = "istio-system"
  }

  depends_on = [null_resource.istio]
}