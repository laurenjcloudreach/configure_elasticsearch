terraform {
  backend "s3" {
    bucket = "ta-challenge-elk-team-3"
    key    = "sprint3/challenge/elk-stack/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}