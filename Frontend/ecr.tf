resource "aws_ecr_repository" "frontend_repo" {
  name = "frontend-image-repo"
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.frontend_repo.repository_url
}

resource "null_resource" "build_and_push_image" {
  depends_on = [aws_ecr_repository.frontend_repo]

  provisioner "local-exec" {
    command = "wsl sh ./sources/build.sh ${aws_ecr_repository.frontend_repo.repository_url}"
  }
}
