variable "vm_name" {
  description = "Nom de la VM"
  type        = string
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

variable "subnet_id" {
  description = "ID du subnet où déployer la VM"
  type        = string
}

variable "private_ip" {
  description = "IP privée statique"
  type        = string
}

variable "vm_size" {
  description = "Taille de la VM Azure"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Nom d'utilisateur admin"
  type        = string
  default     = "azureuser"
}

variable "ssh_pub_key" {
  description = "Clé SSH publique"
  type        = string
}

variable "disk_size_gb" {
  description = "Taille du disque OS en GB"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags Azure"
  type        = map(string)
  default     = {}
}
