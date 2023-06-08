provider "aws" {
  alias  = "eu-east-1"  
  region = "us-east-1"
  default_tags {
    tags = {
      author     = "Grupo13"
      version    = 1
      university = "ITBA"
      subject    = "Redes"
      created-by = "terraform"
    }
  }
}

provider "aws" {
  alias = "us-east-2"
  region = "us-east-2"

  default_tags {
    tags = {
      author     = "Grupo13"
      version    = 1
      university = "ITBA"
      subject    = "Redes"
      created-by = "terraform"
    }
  }
}