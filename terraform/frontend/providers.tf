provider "aws" {
  alias  = "aws"  
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