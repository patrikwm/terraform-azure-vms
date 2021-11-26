# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "ResourceGroup" {
    name     = "${var.prefix}-rg"
    location = var.location

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.prefix}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.ResourceGroup.name

    tags = {
        environment = "Terraform Demo"
    }
}

# Create subnet
resource "azurerm_subnet" "vm-subnet" {
    name                 = "${var.prefix}-Subnet"
    resource_group_name  = azurerm_resource_group.ResourceGroup.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "public_ip" {
    name                         = "${var.prefix}-PublicIP"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.ResourceGroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "NetworkSecurityGroup" {
    name                = "${var.prefix}-NetworkSecurityGroup"
    location            = var.location
    resource_group_name = azurerm_resource_group.ResourceGroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTPS_8443"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "${var.prefix}-NIC"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.ResourceGroup.name

    ip_configuration {
        name                          = "${var.prefix}-NIC-Configuration"
        subnet_id                     = azurerm_subnet.vm-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.public_ip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "interface-nsg" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.NetworkSecurityGroup.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.ResourceGroup.name
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "StorageAccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.ResourceGroup.name
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
    name                  = "${var.prefix}-VM"
    location              = var.location
    resource_group_name   = azurerm_resource_group.ResourceGroup.name
    network_interface_ids = [azurerm_network_interface.nic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "${var.vm_publisher}"
        offer     = "${var.vm_offer}"
        sku       = "${var.vm_sku}"
        version   = "${var.vm_version}"
    }


    computer_name  = "${var.prefix}"
    admin_username = "${var.vm_admin}"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "${var.vm_admin}"
        public_key     = "${var.id_rsa_pub}"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.StorageAccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}