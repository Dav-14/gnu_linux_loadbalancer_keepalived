resource "libvirt_volume" "os_image" {
  count  = var.globalCount
  name   = "${var.hostname}-${count.index}-os_image"
  pool   = "default"
  source = "${var.base_image_prefix}-${count.index}.qcow2"
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
    public_key = file(var.public_key_path)
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

resource "libvirt_domain" "domain-debian" {
  count = var.globalCount
  
  # domain name in libvirt, not hostname
  name   = "${var.hostname}-${count.index}"
  memory = var.memoryMB
  vcpu   = var.cpu

  autostart  = true
  qemu_agent = true # Parameter Wait for IP

  disk {
    volume_id = libvirt_volume.os_image[count.index].id
  }

  disk {
    volume_id = libvirt_volume.worker-data[count.index].id
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true # Parameter Wait for IP
  }


  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

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

}

output "ips" {    # Parameter Wait for IP, with wait_for_lease && qemu_agent
  value = libvirt_domain.domain-debian.*.network_interface.0.addresses
}


data "template_file" "inventory" {
  template = file("${path.module}/inventory.tpl")
  vars = {
    master_hostname          = libvirt_domain.domain-debian[0].name
    master_host_ip           = libvirt_domain.domain-debian[0].network_interface[0].addresses[0]
    master_ssh_private_key   = var.private_key_path
    other_servers            = jsonencode([
      for instance in slice(libvirt_domain.domain-debian, 1, length(libvirt_domain.domain-debian)) : {
        hostname = instance.name
        ip       = instance.network_interface[0].addresses[0]
      }
    ])
    # Add more variables as needed
  }
}

resource "null_resource" "inventory_file" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > inventory/inventory.ini"
  }
  depends_on = [libvirt_domain.domain-debian]
}