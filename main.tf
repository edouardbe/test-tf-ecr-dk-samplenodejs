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

locals {
    aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.us-east-1.amazonaws.com"
}

data "aws_caller_identity" "current" {}
data "aws_ecr_authorization_token" "token" {}

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

resource "docker_registry_image" "sample-nodejs" {
  name = "${aws_ecr_repository.test-tf-ecr-dk-samplenodejs.repository_url}:latest"
  insecure_skip_verify = true
  keep_remotely = true
}