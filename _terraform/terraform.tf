terraform {
  required_version = ">= 0.13"

  required_providers {
    cloudflare = {
      version = "~> 2.0"
      source  = "terraform-providers/cloudflare"
    }
    google-beta = {
      version = "~> 3.38.0"
      source  = "hashicorp/google-beta"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

provider "google-beta" {
  project = var.gcp_project
  zone    = var.zone
}

# vars

variable "cluster" {
  default = "cluster23"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "instance_ip" {
  default = "34.123.30.168"
}

# gcp

variable "gcp_project" {
  default = "com-seankhliao"
}

# cloudflare

variable "cloudflare_email" {
  default = "seankhliao@gmail.com"
}

variable "cloudflare_api_key" {
  type = string
}

variable "cloudflare_zone_id" {
  default = "6bac96a6822dc2e0293ad5ce09767e19"
}
