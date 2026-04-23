# Module VM

Crée une VM Linux Ubuntu 22.04 sur Azure avec IP publique statique et NIC.

## Usage

```hcl
module "my_vm" {
  source              = "../../modules/vm"
  vm_name             = "k8s-control-plane"
  location            = "westeurope"
  resource_group_name = "RG-WBER-EUW"
  subnet_id           = module.network.subnet_id
  private_ip          = "10.0.1.10"
  vm_size             = "Standard_B2s"
  ssh_pub_key         = var.ssh_pub_key
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| vm_name | Nom de la VM | string | - |
| location | Région Azure | string | westeurope |
| resource_group_name | Resource Group | string | - |
| subnet_id | ID du subnet | string | - |
| private_ip | IP privée statique | string | - |
| vm_size | SKU Azure | string | Standard_B2s |
| admin_username | User admin | string | azureuser |
| ssh_pub_key | Clé SSH pub | string | - |
| disk_size_gb | Taille disque OS | number | 30 |
| tags | Tags Azure | map(string) | {} |

## Outputs

| Name | Description |
|------|-------------|
| public_ip | IP publique |
| private_ip | IP privée |
| vm_name | Nom de la VM |
