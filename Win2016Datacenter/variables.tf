variable "location"               { default = "northeurope" }
variable "prefix"                 { default = "windows2016" }
variable "vm_admin"               { default = "azureuser" }
variable "vm_password"            { default = "M3GaPASSWORD!" }
variable "vm_publisher"           { default = "MicrosoftWindowsServer" }
variable "vm_offer"               { default = "WindowsServer" }
variable "vm_sku"                 { default = "2016-Datacenter" }
variable "vm_version"             { default = "latest" }