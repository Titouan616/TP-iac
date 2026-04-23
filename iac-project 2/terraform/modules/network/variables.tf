variable "prefix" {
  description = "Préfixe pour nommer les ressources"
  type        = string
  default     = "k8s"
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR du VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR du subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "tags" {
  description = "Tags Azure"
  type        = map(string)
  default     = {}
}
