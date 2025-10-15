terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "azurerm" {
  features {}
}

# 1️⃣ Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-private-vm-demo"
  location = "East US"
}

# 2️⃣ Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-private"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 3️⃣ Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4️⃣ Network Interface (NO public IP)
resource "azurerm_network_interface" "nic" {
  name                = "nic-private-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    # Note: No public_ip_address_id attached
  }
}

# 5️⃣ Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "private-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = "P@ssword12345!"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  # Optional: disable boot diagnostics (to simplify)
  boot_diagnostics {
    storage_account_uri = null
  }
}
