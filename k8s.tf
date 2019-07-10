data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig.tpl")

  vars = {
    data = azurerm_kubernetes_cluster.aks.kube_config_raw
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = var.kubeconfig_path

  provisioner "local-exec" {
    command = "helm init --client-only"
    environment = {
      KUBECONFIG = var.kubeconfig_path
    }
  }
}

resource "kubernetes_service_account" "tiller_sa" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }

  depends_on = [azurerm_kubernetes_cluster.aks]
}

resource "kubernetes_cluster_role_binding" "tiller_sa_cluster_admin_rb" {
    metadata {
        name = "tiller-cluster-role"
    }
    role_ref {
        kind = "ClusterRole"
        name = "cluster-admin"
        api_group = "rbac.authorization.k8s.io"
    }
    subject {
        kind = "ServiceAccount"
        name = kubernetes_service_account.tiller_sa.metadata.0.name
        namespace = "kube-system"
        api_group = ""
    }

    depends_on = [azurerm_kubernetes_cluster.aks]
}

resource "kubernetes_namespace" "hipster" {
  metadata {

    labels = {
      istio-injection = "enabled"
    }

    name = "hipster"
  }

  depends_on = [azurerm_kubernetes_cluster.aks]
}

resource "null_resource" "hipster" {
  
  provisioner "local-exec" {
    command = "kubectl apply --kubeconfig=${var.kubeconfig_path} -f ./hipster-app/kubernetes-manifests.yaml"
  }

  depends_on = [kubernetes_namespace.hipster, helm_release.istio]
}

resource "null_resource" "istio" {
  
  provisioner "local-exec" {
    command = "kubectl apply --kubeconfig=${var.kubeconfig_path} -f ./hipster-app/istio-manifests.yaml"
  }

  depends_on = [kubernetes_namespace.hipster, helm_release.istio]
}