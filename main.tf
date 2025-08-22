provider "azurerm" {
  features {}
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
}

variable "ARM_CLIENT_ID" {
  type = string
}

variable "ARM_CLIENT_SECRET" {
  type = string
}

variable "ARM_TENANT_ID" {
  type = string
}

resource "azurerm_resource_group" "alert" {
  name     = "Alert"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.alert.location
  resource_group_name = azurerm_resource_group.alert.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.alert.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  resource_group_name = azurerm_resource_group.alert.name
  location            = azurerm_resource_group.alert.location
  sku                 = "Standard_DS1_v2"
  instances           = 2
  upgrade_policy_mode = "Automatic"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "example-nic"
    primary = true

    ip_configuration {
      name      = "example-ip-config"
      subnet_id = azurerm_subnet.example.id
    }
  }
}

resource "azurerm_consumption_budget_resource_group" "example" {
  name              = "example-budget"
  resource_group_id = azurerm_resource_group.alert.id

  amount     = 100
  time_grain = "Monthly"

  time_period {
    start_date = "2024-01-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 0.8
    operator       = "EqualTo"
    contact_emails = ["user@example.com"]
  }
}

