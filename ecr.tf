# ecr.tf | Elastic Container Repository

resource "aws_ecr_repository" "aws-ecr-web" {
  name = "${var.app_name}-${var.app_environment}-ecr-web"
  tags = {
    Name        = "${var.app_name}-ecr-web"
    Environment = var.app_environment
  }
}


resource "aws_ecr_repository" "aws-ecr-api" {
  name = "${var.app_name}-${var.app_environment}-ecr-api"
  tags = {
    Name        = "${var.app_name}-ecr-api"
    Environment = var.app_environment
  }
}