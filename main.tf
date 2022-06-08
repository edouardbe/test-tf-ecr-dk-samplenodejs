terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16"
    }
  }
}

provider "aws" {
    region = "us-east-1"
    profile = "test-tf-ecr-dk-samplenodejs"
}

data "aws_region" "current_region" {}
data "aws_caller_identity" "current" {}
data "aws_ecr_authorization_token" "token" {}

locals {
    aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current_region.name}.amazonaws.com"
}

provider "docker" {
  registry_auth {
    address  = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "aws_ecr_repository" "test-tf-ecr-dk-samplenodejs" {
  name = "test-tf-ecr-dk-samplenodejs"
}

resource "docker_registry_image" "test-tf-ecr-dk-samplenodejs" {
  name = "${local.aws_ecr_url}/${aws_ecr_repository.test-tf-ecr-dk-samplenodejs.name}:latest"
  build {
    context = "${path.cwd}"
}