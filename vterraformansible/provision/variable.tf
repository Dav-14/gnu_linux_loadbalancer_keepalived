// variables that can be overriden
variable "domain" { default = "david-ragot.solutions" }
variable "ip_type" { default = "dhcp" } # dhcp is other valid type
variable "memoryMB" { default = 1024 * 2 }
variable "cpu" { default = 2 }
variable "hostname" { default = "test" }
variable "globalCount" { default = 3 }
variable "private_key_path" {default = "~/.ssh/id_gnu_linux" }
variable "base_image_name" { defdefault = "debian-11-genericcloud-amd64"}