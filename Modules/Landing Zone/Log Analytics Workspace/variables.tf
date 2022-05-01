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


variable "location" {
  description = "(Required) location where this resource has to be created"
  default = "westeurope"
}
variable "prefix" {
    description = "customer prefix"
    default = "jvn"
}
variable "environment" {
    description = "prd,uat"
    default = "prd"
  
}
