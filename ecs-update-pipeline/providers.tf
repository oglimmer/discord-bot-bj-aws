terraform {
  required_providers {
    aws = ">= 2.7.0"
  }
}

provider "aws" {
    region  = var.project_region
}
