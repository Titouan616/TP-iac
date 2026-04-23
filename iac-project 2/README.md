# IaC Project — Kubernetes sur Azure

Infrastructure as Code complète : **Terraform + Ansible + GitLab CI**  
Cluster Kubernetes (1 control plane + 2 workers) sur Azure `westeurope`, Resource Group `RG-WBER-EUW`.

---

## Architecture

```
Azure - westeurope / RG-WBER-EUW
└── VNet: 10.0.0.0/16
    └── Subnet: 10.0.1.0/24
        ├── k8s-dev-cp   (Standard_B2s)  10.0.1.10  ← control plane
        ├── k8s-dev-w1   (Standard_B2s)  10.0.1.11  ← worker 1
        └── k8s-dev-w2   (Standard_B2s)  10.0.1.12  ← worker 2
```

## Stack technique

| Outil | Rôle |
|-------|------|
| Terraform `hashicorp/azurerm` | Provisioning VNet, NSG, VMs |
| Ansible | Hardening OS + installation Kubernetes |
| kubeadm | Bootstrap du cluster K8s |
| Flannel | CNI réseau pods (`10.244.0.0/16`) |
| GitLab CI | Pipeline CI/CD — 4 stages traçables |

---

## Prérequis

### 1. Azure CLI installé et connecté

```bash
# Installer Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Se connecter
az login

# Vérifier que le Resource Group existe
az group show --name RG-WBER-EUW
# Si non : az group create --name RG-WBER-EUW --location westeurope
```

### 2. Service Principal pour GitLab CI

```bash
# Créer un service principal avec droits Contributor sur le RG
az ad sp create-for-rbac \
  --name "sp-iac-gitlab" \
  --role Contributor \
  --scopes /subscriptions/$(az account show --query id -o tsv)/resourceGroups/RG-WBER-EUW

# La commande retourne :
# {
#   "appId":       "→ ARM_CLIENT_ID",
#   "password":    "→ ARM_CLIENT_SECRET",
#   "tenant":      "→ ARM_TENANT_ID"
# }

# Récupérer le subscription ID
az account show --query id -o tsv  # → ARM_SUBSCRIPTION_ID
```

### 3. Générer une paire de clés SSH

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
cat ~/.ssh/id_rsa.pub   # → SSH_PUBLIC_KEY dans GitLab
```

---

## Variables GitLab CI/CD

Configurer dans **GitLab → Settings → CI/CD → Variables** (toutes en "Masked") :

| Variable | Description | Exemple |
|----------|-------------|---------|
| `ARM_CLIENT_ID` | App ID du service principal | `xxxxxxxx-xxxx-...` |
| `ARM_CLIENT_SECRET` | Secret du service principal | `xxxxxxxxxxxxx` |
| `ARM_TENANT_ID` | Tenant Azure AD | `xxxxxxxx-xxxx-...` |
| `ARM_SUBSCRIPTION_ID` | ID de la subscription Azure | `xxxxxxxx-xxxx-...` |
| `SSH_PRIVATE_KEY` | Contenu de `~/.ssh/id_rsa` | `-----BEGIN RSA...` |
| `SSH_PUBLIC_KEY` | Contenu de `~/.ssh/id_rsa.pub` | `ssh-rsa AAAA...` |
| `TF_WORKSPACE` | Workspace Terraform | `dev` |

> ⚠️ **Aucun credential ne doit apparaître dans le code source — critère éliminatoire.**

---

## Lancement manuel (local)

### Étape 1 — Terraform

```bash
cd terraform/envs/azure

# Copier et remplir le fichier de variables
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars : ssh_pub_key = "$(cat ~/.ssh/id_rsa.pub)"

# Authentification Azure CLI (remplace le service principal en local)
az login

# Initialiser
terraform init

# Sélectionner le workspace
terraform workspace new dev || terraform workspace select dev

# Planifier et appliquer
terraform plan
terraform apply

# Voir les outputs (IPs des VMs)
terraform output
```

### Étape 2 — Ansible

```bash
cd ansible

# L'inventory a été généré automatiquement par Terraform
cat inventory/hosts.ini

# Tester la connectivité (attendre ~60s après terraform apply)
ansible all -m ping

# Appliquer hardening + Kubernetes
ansible-playbook playbooks/site.yml -v
```

### Étape 3 — Vérifier le cluster

```bash
CONTROL_PLANE_IP=$(terraform -chdir=terraform/envs/azure output -raw control_plane_public_ip)
ssh azureuser@$CONTROL_PLANE_IP "kubectl get nodes -o wide"
```

Résultat attendu :
```
NAME            STATUS   ROLES           AGE   VERSION
k8s-dev-cp      Ready    control-plane   5m    v1.30.x
k8s-dev-w1      Ready    <none>          3m    v1.30.x
k8s-dev-w2      Ready    <none>          3m    v1.30.x
```

---

## Pipeline GitLab CI

Déclenché sur chaque push vers `main` :

```
validate → provision → configure → verify
```

| Stage | Job | Description |
|-------|-----|-------------|
| validate | `tf:validate` | `terraform validate` + `fmt -check` |
| provision | `tf:plan` | Plan Terraform (artefact tfplan) |
| provision | `tf:apply` | Apply + génération `hosts.ini` Ansible |
| configure | `ansible:hardening` | Hardening OS, fail2ban, auditd, sysctl |
| configure | `ansible:k8s` | containerd, kubeadm, bootstrap, join |
| verify | `kubectl:verify` | `kubectl get nodes` — critère de rendu |

---

## Structure du projet

```
.
├── terraform/
│   ├── modules/
│   │   ├── vm/              # Module VM Azure réutilisable
│   │   │   ├── main.tf      # azurerm_linux_virtual_machine + NIC + PIP
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── README.md
│   │   └── network/         # Module réseau Azure
│   │       ├── main.tf      # VNet + Subnet + NSG + règles
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── README.md
│   └── envs/
│       └── azure/
│           ├── main.tf              # Instancie network + 3 VMs
│           ├── variables.tf
│           ├── outputs.tf           # IPs + commandes SSH
│           ├── inventory.tpl        # Template inventory Ansible
│           └── terraform.tfvars.example
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts.ini               # Généré par Terraform (gitignored)
│   ├── playbooks/
│   │   └── site.yml                # Playbook principal
│   └── roles/
│       ├── hardening/              # SSH, fail2ban, auditd, sysctl, swap
│       └── k8s-node/               # containerd, kubeadm, bootstrap, join
├── .gitlab-ci.yml
├── .gitignore
└── README.md
```

---

## Phase 2 — Refacto (Remote State Azure Blob)

```bash
# Créer le storage account pour le state Terraform
az storage account create \
  --name tfstateiac$RANDOM \
  --resource-group RG-WBER-EUW \
  --location westeurope \
  --sku Standard_LRS

az storage container create \
  --name tfstate \
  --account-name <NOM_STORAGE_ACCOUNT>

# Puis décommenter le bloc backend "azurerm" dans terraform/envs/azure/main.tf
# et relancer : terraform init -reconfigure
```

## Idempotence (test destroy + recreate)

```bash
cd terraform/envs/azure
terraform destroy -auto-approve
terraform apply -auto-approve
# Puis relancer Ansible — le résultat doit être identique
```
