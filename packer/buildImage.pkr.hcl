variable "owners" {}
variable "filter_name" {}
variable "user" {}
variable "cmd" {}

packer {
    required_plugins {
        amazon = {
            version = ">= 1.2.8"
            source  = "github.com/hashicorp/amazon"
        }
        ansible = {
          version = "~> 1"
          source = "github.com/hashicorp/ansible"
        }
    }
}

source "amazon-ebs" "ubuntu" {
    ami_name      = "xyz"
    instance_type = "t2.micro"
    region        = "us-east-1"
    source_ami_filter {
        filters = {
            name                = var.filter_name
            root-device-type    = "ebs"
            "block-device-mapping.volume-type" = "gp2"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners      = var.owners
    }
    ssh_username = var.user
}

build {
    sources = [
        "source.amazon-ebs.ubuntu"
    ]
    provisioner "shell" {
        inline = var.cmd
    }
    provisioner "ansible" {
        playbook_file = "../ansible/postgress_install.yaml"
    } 
}

