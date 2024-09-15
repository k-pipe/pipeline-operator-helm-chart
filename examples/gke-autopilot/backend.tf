############################
#  backend to store state  #
############################
terraform {
  backend "gcs" {
    prefix  = "terraform"
  }
}
