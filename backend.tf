terraform {
  backend "s3" {
    bucket = "ta-challenge-elk-team-3"
    key    = "elasticsearch/terraform.tfstate"
    dynamodb_table = "terraform-lock"
  }
}