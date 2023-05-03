
variable "location" {
  type        = string
  description = "La región donde se desplegarán los recursos"
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "El nombre del grupo de recursos donde se crearán los recursos"
  default     = "rg-dev"
}

variable "crm_subnet_id" {
  type        = string
  description = "El ID de la subred donde se conectará la interfaz de red de la VM"
  default     = "/subscriptions/d0ff7b71-9926-4d0f-b630-4c832323cab4/resourceGroups/rg-dev/providers/Microsoft.Network/virtualNetworks/dev-vnet/subnets/dev-crm-subnet"
}

variable "admin_username" {
  type        = string
  description = "El nombre de usuario para la cuenta de administrador de la VM"
  default     = "cilut"
}

variable "admin_password" {
  type        = string
  description = "La contraseña para la cuenta de administrador de la VM"
  default     = "+3574+"
}

variable "ssh_public_key" {
  type        = string
  description = "La clave pública SSH para la autenticación de SSH"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ2F/7VCzWAm1MGGgM9iNebZoGAVH0w1YcF+gHAvl6bHocnWscU/pvvRLI6tzQZ6x8U6WQylDLbDNs6uhErKq3zC+BhgdBSrFCrCqx9dLxPxJFkWudcYAm/6HlyvhePf0K8zN/KJU6xb/LN6xM2Dk1C20sQaAdb1D3qzKGrW8aT72PfqXrTUMTjT40G8RmzyKwsv4z7mbDWy1OLbJGAEuLBEQX9MIP3MJdxcPJpm7V5l5Yaxa5Kz/d5QyW8AWADeEKVKH9brGxLxCOZn97iY5M5aL+5a5JzW5ze1H55G0EGXO89OoOfwoh0CXGFm4afOvFq3/gzf8gT7TXpTzT6vZIW83gW8sXjYh2EZ1EQx/dx6aLdmd4oj4fjKw4lwiaM+zZ48G68fSPT24Zn90jG40d/xpMt5y+IwzLlKYru5vyF2E7ytK5rBpwX9YrRbRjV7zhdjnHwFV7zCjKZu3qYZCtGZAzp9slYUy8zyBqFO/FHcT6U0="
}
