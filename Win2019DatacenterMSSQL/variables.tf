variable "location"               { default = "northeurope" }
variable "prefix"                 { default = "windows2019" }
variable "vm_admin"               { default = "azureuser" }
variable "vm_password"            { default = "M3GaPASSWORD!" }
variable "vm_publisher"           { default = "MicrosoftSQLServer" }
variable "vm_offer"               { default = "sql2017-ws2019" }
variable "vm_sku"                 { default = "sqldev" }
variable "vm_version"             { default = "latest" }
variable "vm_size"                { default = "Standard_DS2_v2" }