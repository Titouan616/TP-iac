output "control_plane_public_ip" {
  description = "IP publique du control plane"
  value       = module.control_plane.public_ip
}

output "worker_1_public_ip" {
  description = "IP publique du worker 1"
  value       = module.worker_1.public_ip
}

output "worker_2_public_ip" {
  description = "IP publique du worker 2"
  value       = module.worker_2.public_ip
}

output "all_public_ips" {
  description = "Toutes les IPs publiques"
  value = {
    control_plane = module.control_plane.public_ip
    worker_1      = module.worker_1.public_ip
    worker_2      = module.worker_2.public_ip
  }
}

output "ssh_commands" {
  description = "Commandes SSH prêtes à l'emploi"
  value = {
    control_plane = "ssh ${var.admin_username}@${module.control_plane.public_ip}"
    worker_1      = "ssh ${var.admin_username}@${module.worker_1.public_ip}"
    worker_2      = "ssh ${var.admin_username}@${module.worker_2.public_ip}"
  }
}
