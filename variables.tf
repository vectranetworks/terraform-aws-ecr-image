variable "dockerfile_dir" {
  type = string
  description = "The directory that contains the Dockerfile"
}

variable "ecr_repository_url" {
  type        = string
  description = "Full url for the ECR repository"
}

variable "docker_image_tag" {
  type        = string
  description = "This is the tag which will be used for the image that you created"
  default     = "latest"
}

variable "aws_profile" {
  type = string
  description = "AWS_PROFILE to set for bash commands. Should match the provider"
}

variable "aws_region" {
  type = string
  description = "AWS_DEFAULT_REGION to set for bash commands."
}