variable "rg" {
  type = list(object({
    name   = string
    region = string
  }))
}

