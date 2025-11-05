terraform {
  backend "s3" {
    region         = "ap-northeast-1"
    dynamodb_table = "terraform"
    bucket         = "terraform.mizzy.org"
    key            = "management.tfstate"
    session_name   = "management"
    encrypt        = true
    profile        = "management"
  }
}

resource "aws_s3_bucket" "terraform_mizzy_org" {
  bucket = "terraform.mizzy.org"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
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
