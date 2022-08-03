resource "google_artifact_registry_repository" "images" {
  count = var.repoexists ? 1 : 0
  location      = var.region
  project       = var.project
  repository_id = "${var.repoid}-images"
  description   = "Genesys container repository"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "charts" {
  count = var.repoexists ? 1 : 0
  location      = var.region
  project       = var.project
  repository_id = "${var.repoid}-charts"
  description   = "Genesys helm chart repository"
  format        = "DOCKER"
}

resource "null_resource" "remoteimageregistrylogin" {
  # Login to remote registry
  provisioner "local-exec" {
    command = <<-EOT
      podman login -u ${var.remoteregistry_user} -p ${var.remoteregistry_pass} ${var.remoteregistry}
    EOT
  }
  depends_on = [google_artifact_registry_repository.images]
}

resource "null_resource" "remotechartregistrylogin" {
  # Login to remote registry
  provisioner "local-exec" {
    command = <<-EOT
      helm repo add helm-multicloud ${var.remotehelm} --username ${var.remoteregistry_user} --password ${var.remoteregistry_pass} && helm repo update
    EOT
  }
  depends_on = [google_artifact_registry_repository.charts]
}

resource "null_resource" "chart-pull-push" {
  # Pull charts
  for_each = var.charts
  provisioner "local-exec" {
    command = <<-EOT
      helm pull helm-multicloud/${each.key} --version ${each.value}
      helm push ${each.key}-${each.value}.tgz oci://${var.region}-docker.pkg.dev/${var.project}/${var.repoid}-charts
    EOT
  }
  depends_on = [null_resource.remotechartregistrylogin]
}

resource "null_resource" "image-pull-tag-push-prune" {
  # Pull containers
  for_each = var.images
  provisioner "local-exec" {
    command = <<-EOT
      podman pull ${var.remoteregistry}/${each.key}:${each.value}
      podman tag ${var.remoteregistry}/${each.key}:${each.value} ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}-images/${each.key}:${each.value}
      podman push ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}-images/${each.key}:${each.value}
      podman image prune -af
    EOT
  }
  depends_on = [null_resource.remoteimageregistrylogin]
}