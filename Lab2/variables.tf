variable "var_custom_vpc" {
  type          = string
  description   = "a custom vpc cidr block ip range"
}

variable "var_public_subnet_cidr" {
  type          = string
  description   = "a public subnet cidr"
}

variable "var_private_subnet_cidr" {
  type          = string
  description   = "a private subnet cidr"
}