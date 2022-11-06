provider "aws" {

  region = "us-east-1"
}


terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform"
    key            = "app/s3/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform"
    encrypt        = true
  }
}