terraform {
  backend "s3" {
    region         = "ap-northeast-1"
    dynamodb_table = "terraform"
    bucket         = "terraform.mizzy.org"
    key            = "master.tfstate"
    session_name   = "master"
    encrypt        = true
  }
}
