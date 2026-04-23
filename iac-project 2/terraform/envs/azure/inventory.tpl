# Fichier généré automatiquement par Terraform outputs
# NE PAS MODIFIER MANUELLEMENT - toute modification sera écrasée
# Généré le : voir git log

[control_plane]
${control_plane_ip} ansible_user=${admin_username} ansible_ssh_private_key_file=~/.ssh/id_rsa

[workers]
${worker_1_ip} ansible_user=${admin_username} ansible_ssh_private_key_file=~/.ssh/id_rsa
${worker_2_ip} ansible_user=${admin_username} ansible_ssh_private_key_file=~/.ssh/id_rsa

[k8s_cluster:children]
control_plane
workers

[k8s_cluster:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
