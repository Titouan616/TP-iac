# Module Network

Crée le réseau Azure : VNet, Subnet, NSG avec règles pour SSH, K8s API (6443) et NodePort.

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | ID du VNet |
| subnet_id | ID du subnet (passé aux VMs) |
| nsg_id | ID du NSG |
