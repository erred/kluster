resource "null_resource" "kind" {
  triggers = {
    kind_config = file("kind.k8s.yaml")
  }

  # lifecycle {
  #   create_before_destroy = true
  # }

  provisioner "local-exec" {
    command = "kind create cluster --config kind.k8s.yaml --name k"
  }
}
