variable "vpc_name" {
    type = string
    description = "vpc name"
}

variable "cidr_block" {
    default = "10.0.0.0/16"
    type = string
    description = "vpc cidr block"

}

variable "enable_dns_hostnames" {
    default = true
    type = bool
    description = "enable dns hostnames"
}

variable "enable_dns_support" {
    default = true
    type = bool
    description = "enable dns support"
}

# subnet
variable "public_cidr" {
    type = list(string)
    description = "public subnet cidr list"
    default = []
    
    validation {
        condition = length(var.public_cidr) <= length(var.azs)
        error_message = "Public subnet count (${length(var.public_cidr)}) cannot exceed the number of availability zones (${length(var.azs)}). This prevents naming conflicts and ensures even distribution."
    }
}

variable "private_cidr" {
    type = list(string)
    description = "private subnet cidr list"
    default = []
    
    validation {
        condition = length(var.private_cidr) <= length(var.azs)
        error_message = "Private subnet count (${length(var.private_cidr)}) cannot exceed the number of availability zones (${length(var.azs)}). This prevents naming conflicts and ensures even distribution."
    }
}

variable "db_cidr" {
    type = list(string)
    description = "db subnet cidr list"
    default = []
    
    validation {
        condition = length(var.db_cidr) <= length(var.azs)
        error_message = "DB subnet count (${length(var.db_cidr)}) cannot exceed the number of availability zones (${length(var.azs)}). This prevents naming conflicts and ensures even distribution."
    }
}

variable "etc_cidr" {
    type = list(string)
    description = "etc subnet cidr list"
    default = []
    
    validation {
        condition = length(var.etc_cidr) <= length(var.azs)
        error_message = "ETC subnet count (${length(var.etc_cidr)}) cannot exceed the number of availability zones (${length(var.azs)}). This prevents naming conflicts and ensures even distribution."
    }
}

variable "azs" {
    type = list(string)
    description = "az list"
    default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "igw" {
    type = bool
    default = true
    description = "create igw"
}

variable "nat" {
    type = bool
    default = false
    description = "create nat gateway"
}

variable "nat_count" {
    type = number
    default = 0
    description = "nat gateway count"
    
    validation {
        condition = var.nat_count <= length(var.azs)
        error_message = "NAT Gateway count (${var.nat_count}) cannot exceed the number of availability zones (${length(var.azs)}). This prevents naming conflicts and ensures even distribution."
    }
}

# tags
variable "vpc_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the VPC"
}

variable "subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all subnets"
}
