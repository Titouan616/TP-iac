variable "location" {
  description = "Région Azure"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Resource Group existant dans Azure"
  type        = string
  default     = "RG-TFAU-EUW"
}

variable "admin_username" {
  description = "Nom d'utilisateur SSH sur les VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_pub_key" {
  description = "Clé SSH publique injectée dans les VMs"
  type        = string
}

variable "vm_size_control_plane" {
  description = "SKU Azure pour le control plane"
  type        = string
  default     = "Standard_B2s"  # 2 vCPU, 4GB RAM
}

variable "vm_size_worker" {
  description = "SKU Azure pour les workers"
  type        = string
  default     = "Standard_B2s"  # 2 vCPU, 4GB RAM
}
