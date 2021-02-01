terraform {
  required_version = ">= 0.12.16"
  required_providers {
    aws = ">= 2.42"
  }
}

# Checks if build folder has changed
data "external" "build_dir" {
  program = ["bash", "${path.module}/bin/dir_md5.sh", dirname(var.docker_path)]
}

data "aws_caller_identity" "current" {}

# Builds test-service and pushes it into aws_ecr_repository
resource "null_resource" "ecr_image" {
  triggers = {
    build_folder_content_md5 = data.external.build_dir.result.md5
    build_number = filemd5(var.docker_path)
  }

  # Runs the build.sh script which builds the dockerfile and pushes to ecr
  provisioner "local-exec" {
    command = "AWS_PROFILE=${var.aws_profile} AWS_DEFAULT_REGION=${var.aws_region} AWS_ACCOUNT=${data.aws_caller_identity.current.account_id} bash ${path.module}/bin/build.sh ${var.dockerfile_file_path} ${var.docker_path} ${var.ecr_repository_url}:${var.docker_image_tag}"
  }
}
