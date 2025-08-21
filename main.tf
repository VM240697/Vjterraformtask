provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}

# Create a virtual machine scale set
resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard_DS1_v2"
  instances           = 2

  upgrade_policy {
    mode = "Automatic"
  }

  storage_profile_image_reference {
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
      name      = "example-nic-ipconfig"
      subnet_id = azurerm_subnet.example.id
    }
  }
}

# Create a budget alert
resource "azurerm_consumption_budget_resource_group" "example" {
  name              = "example-budget"
  resource_group_id = azurerm_resource_group.example.id

  amount     = 100
  time_grain = "Monthly"

  time_period {
    start_date = "2023-01-01T00:00:00Z"
    end_date   = "2024-01-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 0.8
    operator       = "EqualTo"
    contact_emails = ["user@example.com"]
  }
}
