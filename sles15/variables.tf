variable "location"               { default = "northeurope" }
variable "prefix"                 { default = "rhel8" }
variable "vm_admin"               { dafault = "azureuser" }
varialbe "id_rsa_pub"             { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeg7RWgFddZN6QalA0RuWip5zGOhtDqILpSjD0c35KybSLj+lBxoQ4Gm1GwhHuTn4npj/I2KayZadfsEUUQ9AvfpI/cJFKefeqyCO1uroS2rETd+S0eoMizoJHEoQ7+h3PTvuzrY+ovwrvB9k/FC9VHwovPMJK7IThyf2rW5IStDU1Do/O/KR7jS/ctIobHlZFn77+Ri78k1pCqw78IixSRmKnKyrZa07uTyr6NpDujiuY/TMumnF5sN1LHMP+Tp3JgOOmMvpwGcWVRI2zBgBNy+hBnDDJ9jsgdBoCON1HA+LNyKe6oPyYwnRT6pq+6tuAs3gyAKs73nu3WWB6waYb" }
variable "vm_publisher"           { default = "SUSE"}
variable "vm_offer"               { default = "SLES"}
variable "vm_sku"                 { default = "12-sp4-gen2"}
variable "vm_version"             { default = "latest"}