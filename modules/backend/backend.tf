terraform {
  backend "s3" {
    bucket = "backend-tf-ramup-mai"
    key = "terraform/mai/terraform.tfstate"
    region = "us-east-1"
#    kms_key_id = ""
  }
}
