# Copier en terraform.tfvars et remplir
# terraform.tfvars est dans .gitignore — ne jamais committer

location            = "westeurope"
resource_group_name = "RG-TFAU-EUW"
admin_username      = "azureuser"
ssh_pub_key         = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtGEzhdIasRKl8ISLfpXGslJScDth84g5pSszHj+eG/b1M8J4LUfn8nAnu6w6lsQmh2TNl1YZHseMgZ19s+S8PTOWRZ5ZQoKtSqCMsN4CvKJviBkn5iUtxGo5qryTzXOGgcwoE/Ukkehmda95+yKE95H9OuaeAGXPTaVAng5CmMBdFwfsQODfalUFJpD4bzllUDuEpFg1rlnMUaaMwoz3zaXHIL5txSsmMb4s5zJR9QNUH4VdfuJRbeUpMa5btrGmSQNi8eqDXDGcEK4TJHORwhb3oM4FSBSSxJlPq9uC6cFb09cR3vGo6M0mSjM7EvgLo/dhhmrTvgc8UHmNttSOEP1pykqS/lUEDApyEIH3A33uS7tXhanifdGPIBaW8FOZMEK6CHYwRusqDMsepjpS04/mKGIA4hpZga6jcZYQSriLOGnAScKM1qi58IU9/9JxkvIvZjPSZC5yi5bovBPNgubtL/ThwTNAHq8F9oP86eQpIeet00etIN1lKdYEt0MXYSv7Fkn5pLE9fUu4oQUXHDPAGKUxqf3UvH9ZeiC1blqUzldrIDzJ6ua4MCENBSV/AYfH1m18A+udjfzwCOMSYjTcp8DfeGMG9ZBDCfoXXlMLUQWLFobzMd7GnZtu4m72RImfRx1eYfR44BW4W6f1PNZXiA3sM2zPIlCHCVzE57Q=="
vm_size_control_plane = "Standard_D2s_v3"
vm_size_worker        = "Standard_D2s_v3"
