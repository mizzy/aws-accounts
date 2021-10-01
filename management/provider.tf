provider "aws" {
  profile = "management"
}

provider "aws" {
  alias   = "oregon"
  region  = "us-west-2"
  profile = "management"
}
