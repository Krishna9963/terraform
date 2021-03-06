provider "azurerm" {  
          #version = "=2.20.0"  #version = "=0.13.1" 
           version = "=2.20.0"
           subscription_id = "3f14e458-7504-4b24-8d6f-0af0bb43dd6e" 
            tenant_id       = "3babfb2d-0e65-4181-8061-dad9a278b59b"  
            client_id       = "d3ac09bc-04ae-4a4c-ac72-aff7d0b6b3ae"  
            features {}  
}
resource "azurerm_resource_group" "RS1" {
  name     = "Firstresource"
  location = "West Europe"
}



# Create a virtual network within the resource group
resource "azurerm_virtual_network" "Vnet1" {
  name                = "Firstvnet1"
  resource_group_name = azurerm_resource_group.RS1.name
  location            = azurerm_resource_group.RS1.location
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet under Vnet 
resource "azurerm_subnet" "Subnet1" {
  name                 = "Firstsubnet1"
  resource_group_name  = azurerm_resource_group.RS1.name
  virtual_network_name = azurerm_virtual_network.Vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create a network interface
resource "azurerm_network_interface" "Network1" {
  name                = "Firstnetwork"
  location            = azurerm_resource_group.RS1.location
  resource_group_name = azurerm_resource_group.RS1.name
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.Subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "VM1"
  location              = azurerm_resource_group.RS1.location
  resource_group_name   = azurerm_resource_group.RS1.name
  network_interface_ids = [azurerm_network_interface.Network1.id]
  vm_size               = "Standard_DS1_v2"



  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "Sravan"
    admin_password = "Sravan@123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}


