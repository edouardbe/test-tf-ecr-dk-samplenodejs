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
}

module "vpc" {
    source                                      = "cn-terraform/networking/aws"
    version                                     = "2.0.15"
    name_prefix                                = "test-tf-ecr-dk-samplenodejs"
    vpc_cidr_block                              = "10.0.0.0/16"
    availability_zones                          = ["us-east-1a","us-east-1b"]
    public_subnets_cidrs_per_availability_zone  = ["10.0.1.0/24","10.0.2.0/24"]
    private_subnets_cidrs_per_availability_zone = ["10.0.101.0/24","10.0.102.0/24"]
}

module "ecs-fargate" {
    source  = "cn-terraform/ecs-fargate/aws"
    version = "2.0.41"
    name_prefix        = "test"
    vpc_id              = module.vpc.vpc_id
    container_image     = "${docker_registry_image.test-tf-ecr-dk-samplenodejs.name}"
    container_name = "test"
    public_subnets_ids  = module.vpc.public_subnets_ids
    private_subnets_ids = module.vpc.private_subnets_ids
    enable_s3_logs = false
    enable_autoscaling = false
    container_cpu = 256
    container_memory = 512
    container_memory_reservation = 256
    desired_count = 1
    enable_s3_bucket_server_side_encryption = false
    lb_https_ports = {}
    lb_stickiness = {
        "cookie_duration": 86400,
        "enabled": false,
        "type": "lb_cookie"
        }
}

output "loadbalancer-address" {
    value = "${module.ecs-fargate.aws_lb_lb_dns_name}"
}
