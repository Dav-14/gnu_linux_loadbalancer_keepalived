// variables that can be overriden
variable "domain" { default = "localhost" }
variable "ip_type" { default = "dhcp" } # dhcp is other valid type

variable "memoryMB" { default = 1024 * 2 }
variable "cpu" { default = 2 }
variable "hostname" { default = "test" }
variable "globalCount" { default = 3 }
variable "private_key_path" {default = "/home/adzttiv/.ssh/gnu_linux" }
variable "public_key_path" {default = "/home/adzttiv/.ssh/gnu_linux.pub" }
variable "base_image_prefix" { default = "debian-11-genericcloud-amd64"}