variable "deploymentDetails" {
    description = "Details on this specific deployment"
    type = object({
        env = string
        locationPrefix = string
        instanceNumber = string 
    })
    default = {
      env = "prod"
      instanceNumber = "001"
      locationPrefix = "eus2"
    }
}

variable "location" {
  description = "Azure location for deployment"
  default = "eastus2"
}

variable "tagsStandard" {
  description = "standard tags for objects created"
  type = object({
      createdBy = string
      createdOn = string
      costCenter = string
      environment = string
      critical = string
  })
  default = {
    costCenter = "IT"
    createdBy = "Shawn Anderson"
    createdOn = "2022/05/01"
    critical = "YES"
    environment = "PROD"
  }
}

variable "dnsServers" {
    description = "list of dns servers for vnets"
    type = list(string)
    default = [ "10.5.0.4","168.63.129.16" ]
}