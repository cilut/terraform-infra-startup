resource "azurerm_public_ip" "example" {
  name                = "publicip-suitecrm"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-suitecrm"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "nic-suitecrm"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig-suitecrm"
    subnet_id                     = var.crm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id

  }

}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_virtual_machine" "example" {
  name                  = "vm-suitecrm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.example.id]

  vm_size                       = "Standard_B2s"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-suitecrm"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-suitecrm"
    admin_username = var.admin_username
    admin_password = "faslkjdgfajshdgVSADAfj45431-ahsdvf"
  }

  os_profile_linux_config {
    disable_password_authentication = false

  }
}


# resource "null_resource" "add_code_terraform_proyecto_devops" {
#   depends_on = [
#     azurerm_virtual_machine.example, azurerm_public_ip.example
#   ]
#   connection {
#     type     = "ssh"
#     user     = var.admin_username
#     password = var.admin_password
#     host     = azurerm_public_ip.example.ip_address
#     agent    = false
#     timeout  = "5m"
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo apt-get install -y apache2 mysql-server php libapache2-mod-php7.2 php-curl php-gd php-intl php-mbstring php-soap php-xml php-zip",
#       "sudo systemctl enable apache2",
#       "sudo systemctl start apache2",
#       "sudo wget -qO- https://download.suitecrm.com/files/157/SuiteCRM-7.11/504/SuiteCRM-7.11.20.zip | sudo tar xvz -C /var/www/html/",
#       "sudo chown -R www-data:www-data /var/www/html/SuiteCRM-7.11.20/",
#       "sudo chmod -R 755 /var/www/html/SuiteCRM-7.11.20/",
#       "sudo systemctl restart apache2"
#     ]
#   }
# }
