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

resource "aws_s3_bucket" "terraform_mizzy_org" {
  bucket = "terraform.mizzy.org"
}

resource "aws_dynamodb_table" "terraform" {
  hash_key       = "LockID"
  name           = "terraform"
  read_capacity  = 1
  write_capacity = 1
  attribute {
    name = "LockID"
    type = "S"
  }
}
