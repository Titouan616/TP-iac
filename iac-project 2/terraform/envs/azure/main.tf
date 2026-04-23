terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }

  
  backend "azurerm" {
    resource_group_name  = "RG-TFAU-EUW"
    storage_account_name = "eiuievbze"
    container_name       = "tfstate"
    key                  = "k8s.tfstate"
   }
}

provider "azurerm" {
  features {}
  # Authentification via Azure CLI (az login) en local
  # ou via variables d'environnement ARM_* en CI/CD
}

# ── Data source : Resource Group existant ─────────────────────────────────────
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# ── Module Network ─────────────────────────────────────────────────────────────
module "network" {
  source = "../../modules/network"

  prefix              = "k8s-${terraform.workspace}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  vnet_cidr           = "10.0.0.0/16"
  subnet_cidr         = "10.0.1.0/24"
  tags                = local.common_tags
}

# ── Control Plane ──────────────────────────────────────────────────────────────
module "control_plane" {
  source = "../../modules/vm"

  vm_name             = "k8s-${terraform.workspace}-cp"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id
  private_ip          = "10.0.1.10"
  vm_size             = var.vm_size_control_plane
  admin_username      = var.admin_username
  ssh_pub_key         = var.ssh_pub_key
  disk_size_gb        = 30
  tags                = local.common_tags
}

# ── Worker 1 ───────────────────────────────────────────────────────────────────
module "worker_1" {
  source = "../../modules/vm"

  vm_name             = "k8s-${terraform.workspace}-w1"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id
  private_ip          = "10.0.1.11"
  vm_size             = var.vm_size_worker
  admin_username      = var.admin_username
  ssh_pub_key         = var.ssh_pub_key
  disk_size_gb        = 30
  tags                = local.common_tags
}

# ── Worker 2 ───────────────────────────────────────────────────────────────────
module "worker_2" {
  source = "../../modules/vm"

  vm_name             = "k8s-${terraform.workspace}-w2"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id
  private_ip          = "10.0.1.12"
  vm_size             = var.vm_size_worker
  admin_username      = var.admin_username
  ssh_pub_key         = var.ssh_pub_key
  disk_size_gb        = 30
  tags                = local.common_tags
}

# ── Génération automatique de l'inventory Ansible ─────────────────────────────
#resource "local_file" "ansible_inventory" {
#  content = templatefile("${path.module}/inventory.tpl", {
#   control_plane_ip = module.control_plane.public_ip
#    worker_1_ip      = module.worker_1.public_ip
#    worker_2_ip      = module.worker_2.public_ip
#    admin_username   = var.admin_username
#  })
#  filename        = "${path.module}/../../../ansible/inventory/hosts.ini"
#  file_permission = "0644"
#}

# ── Tags communs ───────────────────────────────────────────────────────────────
#locals {
#  common_tags = {
#    project     = "iac-k8s"
#    environment = terraform.workspace
#   managed_by  = "terraform"
#  }
#}
