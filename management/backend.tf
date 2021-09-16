terraform {
  backend "s3" {
    region         = "ap-northeast-1"
    dynamodb_table = "terraform"
    bucket         = "terraform.mizzy.org"
    key            = "management.tfstate"
    session_name   = "management"
    encrypt        = true
  }
}
