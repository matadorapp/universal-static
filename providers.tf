provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Cost = "universal-static"
    }
  }
}


provider "aws" {
  alias   = "root"
  region  = "us-east-1"
  profile = "base_role"
  default_tags {
    tags = {
      Cost = "universal-static"
    }
  }
}
