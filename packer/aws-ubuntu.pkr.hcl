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
    ami_name      = "ubuntu"
    instance_type = "t2.micro"
    region        = "us-east-1"
    source_ami_filter {
        filters = {
            name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
            root-device-type    = "ebs"
            "block-device-mapping.volume-type": "gp2",
            virtualization-type = "hvm"
        }
        most_recent = true
        owners      = ["099720109477"]
    }
    ssh_username = "ubuntu"
}

build {
    sources = [
        "source.amazon-ebs.ubuntu"
    ]

    provisioner "ansible" {
        playbook_file = "./ansible/postgress_install.yaml"
    }
}
