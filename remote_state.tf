terraform {
  backend "s3" {
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}
