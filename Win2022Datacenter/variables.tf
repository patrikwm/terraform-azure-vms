variable "location"               { default = "northeurope" }
variable "prefix"                 { default = "windows2022" }
variable "vm_admin"               { default = "azureuser" }
variable "vm_password"            { default = "M3GaPASSWORD!" }
variable "vm_publisher"           { default = "MicrosoftWindowsServer" }
variable "vm_offer"               { default = "WindowsServer" }
variable "vm_sku"                 { default = "2022-datacenter-azure-edition" }
variable "vm_version"             { default = "latest" }
variable "vm_size"                { default = "Standard_DS2_v2" }