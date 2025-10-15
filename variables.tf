variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "rg-terraform-windowsvm"
}

variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for Windows VM"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for Windows VM"
  default     = "Passw0rd1234!"
  sensitive   = true
}
