resource "null_resource" "cluster26" {
  triggers = {
    kind_config = file("kind.k8s.yaml")
  }

  # lifecycle {
  #   create_before_destroy = true
  # }

  provisioner "local-exec" {
    command = "kind create cluster --config kind.k8s.yaml --name cluster26"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name cluster26"
  }
}
