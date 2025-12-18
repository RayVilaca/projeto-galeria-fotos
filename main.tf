terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.12.0"

  backend "s3" {
    bucket = "terraform-womakerscode-hands-on-tfstate"
    region = "us-east-1"
    key    = "womakerscode_hands_on.tfstate"
  }
}
provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "compute" {
  source           = ".//modules/compute"
  buckets          = module.storage.buckets
  ec2_service_role = module.security.ec2_service_role
  vpc              = module.networking.vpc
  security_group   = module.security.security_group
}

module "networking" {
  source = ".//modules/networking"
}

module "security" {
  source  = ".//modules/security"
  vpc_id  = module.networking.vpc.vpc_id
  buckets = module.storage.buckets
}

module "storage" {
  source = ".//modules/storage"
}
