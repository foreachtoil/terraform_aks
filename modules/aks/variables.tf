variable "app_name" {
  type = string
}

variable "location" {
  default = "eastus"
  type = string
}

variable "aks" {
  type = object({
    # az aks get-versions --location "<eastus>" -o table
    version = string
    availability_zones = list(number)
    node_count = number
    #  Standard_B2ms
    size = string
  })
}