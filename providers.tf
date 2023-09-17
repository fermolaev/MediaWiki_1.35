terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.13"
}
# Configure the Yandex Provider
provider "yandex" {
  service_account_key_file = "./key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

# Configure the AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access
  secret_key = var.aws_secret
}
