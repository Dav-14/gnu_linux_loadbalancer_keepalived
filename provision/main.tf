resource "libvirt_volume" "os_image" {
  count  = var.globalCount
  name   = "${var.hostname}-${count.index}-os_image"
  pool   = "default"
  source = "debian-11-genericcloud-amd64-${count.index}.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "worker-data" {
  count = var.globalCount
  name  = "${var.hostname}-${count.index}-worker-data"
  pool  = "default"
}

// Use CloudInit ISO to add ssh-key to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
  count          = var.globalCount
  name           = "${var.hostname}-${count.index}-commoninit.iso"
  pool           = "default"
  user_data      = data.template_cloudinit_config.config[count.index].rendered
  network_config = data.template_file.network_config.rendered
}


data "template_file" "user_data" {
  count    = var.globalCount
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname   = "${var.hostname}-${count.index}"
    fqdn       = "${var.hostname}-${count.index}.${var.domain}"
    public_key = file(var.private_key_path)
  }
}

data "template_cloudinit_config" "config" {
  count         = var.globalCount
  gzip          = false
  base64_encode = false
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.user_data[count.index].rendered
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config_${var.ip_type}.cfg")
}



// Create the machine
resource "libvirt_domain" "domain-debian" {
  count = var.globalCount
  # domain name in libvirt, not hostname
  name   = "${var.hostname}-${count.index}"
  memory = var.memoryMB
  vcpu   = var.cpu

  autostart  = true
  qemu_agent = true

  disk {
    volume_id = libvirt_volume.os_image[count.index].id
  }

  disk {
    volume_id = libvirt_volume.worker-data[count.index].id
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }


  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  # IMPORTANT
  # Ubuntu can hang is a isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }


  # provisioner "remote-exec" {
  #   inline = [
  #     "cloud-init status --wait",
  #   ]

  #   connection {
  #     host     = "${self.network_interface.0.addresses.0}"
  #     type     = "ssh"
  #     user     = "ansible"
  #     private_key = file("${var.private_key_path}")
  #   }
  # }



  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ansible -i inventory-${count.index} --private-key ${var.private_key_path} ../ansible/playbooks/configure_ssh.yml"
  # }
}

# resource "local_file" "ansible_inventory" {
#   content = templatefile("./inventory.tmpl", {
#     hostname        = "${var.hostname}-${count.index}"
#     hosts_ips         = "${libvirt_domain.domain-debian.*.network_interface.0.addresses}"
#     ssh_private_key = "${var.private_key_path}"
#   })
#   filename = "inventory.ini"
# }


output "ips" {
  value = libvirt_domain.domain-debian.*.network_interface.0.addresses
}
