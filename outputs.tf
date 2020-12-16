output "ecr_image_url" {
  value       = "${var.ecr_repository_url}:${var.docker_image_tag}"
  description = "Full URL to image in ECR with tag"
}
output "docker_image_tag" {
  value = var.docker_image_tag
}
output "ecr_repository_url" {
  value = var.ecr_repository_url
}
