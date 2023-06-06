terraform {
  required_version = ">= 1.2.5"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}


# Configure the Libvirt provider
provider "libvirt" {
  uri = "qemu:///system"
}