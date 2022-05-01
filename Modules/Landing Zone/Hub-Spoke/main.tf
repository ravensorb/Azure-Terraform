provider "azurerm" {
  features {}
}

##Create Networking Resource Group for hub-spoke vnet
resource "azurerm_resource_group" "rg-hub-law" {
  name     = "rg-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-law-${var.deploymentDetails.instanceNumber}"
  location = var.location
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}

data "azurerm_log_analytics_workspace" "law" {
  name = "law-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  resource_group_name = "rg-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-law-${var.deploymentDetails.instanceNumber}"  
  depends_on = [
    azurerm_resource_group.rg-hub-law
  ]
}

##Create Networking Resource Group for hub-spoke vnet
resource "azurerm_resource_group" "rg-hub" {
  name     = "rg-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet-${var.deploymentDetails.instanceNumber}"
  location = var.location
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}

resource "azurerm_resource_group" "rg-shared" {
  name     = "rg-shared-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet-${var.deploymentDetails.instanceNumber}"
  location = var.location
 tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}

resource "azurerm_resource_group" "rg-mgmt" {
  name     = "rg-mgmt-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet-${var.deploymentDetails.instanceNumber}"
  location = var.location
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}

resource "azurerm_resource_group" "rg-vms" {
  name     = "rg-vms-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet-${var.deploymentDetails.instanceNumber}"
  location = var.location
 tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}

#VNETs and Subnets
#add custom dns servers from customer
#dns server from Azure and my own dns is also defined here
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "vnet-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  address_space       = ["10.0.0.0/20"]
  dns_servers         = var.dnsServers
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}
resource "azurerm_virtual_network" "shared-vnet" {
  name                = "vnet-shared-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-shared.name
  address_space       = ["10.1.0.0/20"]
  dns_servers         = var.dnsServers
 tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}
resource "azurerm_virtual_network" "mgmt-vnet" {
  name                = "vnet-mgmt-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-mgmt.name
  address_space       = ["10.2.0.0/20"]
  dns_servers         = var.dnsServers
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}
resource "azurerm_virtual_network" "vms-vnet" {
  name                = "vnet-vms-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-vms.name
  address_space       = ["10.3.0.0/20"]
  dns_servers         = var.dnsServers
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}
##Create hub subnets
resource "azurerm_subnet" "hub-snet-management" {
  name                 = "snet-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-hub-management"
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.2.0/28"]
}
resource "azurerm_subnet" "hub-snet-gateway" {
  name                 = "GatewaySubnet" ## Do not change
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.4.0/27"]
}
resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet" ## Do not change
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.3.0/26"]
}
resource "azurerm_subnet" "firewall-subnet" {
  name                 = "AzureFirewallSubnet" ##can also be AzureFirewallManagementSubnet
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.5.0/26"]
}

##Configure diagnostic settings vnets
resource "azurerm_monitor_diagnostic_setting" "vnet-hub-diag" {
  name                        = "diag-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet"
  target_resource_id          = azurerm_virtual_network.hub-vnet.id
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.law.id
  depends_on                  = [azurerm_virtual_network.hub-vnet]
  
  log {
    category = "VMProtectionAlerts"
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "vnet-shared-diag" {
  name                        = "diag-shared-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet"
  target_resource_id          = azurerm_virtual_network.shared-vnet.id
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.law.id
  depends_on                  = [azurerm_virtual_network.shared-vnet]
  
  log {
    category = "VMProtectionAlerts"
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "vnet-mgmt-diag" {
  name                        = "diag-mgmt-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet"
  target_resource_id          = azurerm_virtual_network.mgmt-vnet.id
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.law.id
  depends_on                  = [azurerm_virtual_network.mgmt-vnet]

  log {
    category = "VMProtectionAlerts"
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}
resource "azurerm_monitor_diagnostic_setting" "vnet-vms-diag" {
  name                        = "diag-vms-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet"
  target_resource_id          = azurerm_virtual_network.vms-vnet.id
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.law.id
  depends_on                  = [azurerm_virtual_network.vms-vnet]
  
  log {
    category = "VMProtectionAlerts"
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}

resource "azurerm_network_security_group" "nsg-hub" {
  name                = "nsg-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg-shared" {
  name                = "nsg-shared-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = azurerm_resource_group.rg-shared.location
  resource_group_name = azurerm_resource_group.rg-shared.name
  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_security_group" "nsg-mgmt" {
  name                = "nsg-mgmt-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = azurerm_resource_group.rg-mgmt.location
  resource_group_name = azurerm_resource_group.rg-mgmt.name
  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_security_group" "nsg-vms" {
  name                = "nsg-vms-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = azurerm_resource_group.rg-vms.location
  resource_group_name = azurerm_resource_group.rg-vms.name
  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

## Setup VNET Peering
resource "azurerm_virtual_network_peering" "peer-hub-2-shared" {
  name                      = "peer-hub-2-shared"
  resource_group_name       = azurerm_resource_group.rg-hub.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.shared-vnet.id 
}
resource "azurerm_virtual_network_peering" "peer-shared-2-hub" {
  name                      = "peer-shared-2-hub"
  resource_group_name       = azurerm_resource_group.rg-shared.name
  virtual_network_name      = azurerm_virtual_network.shared-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id 
}
resource "azurerm_virtual_network_peering" "peer-hub-2-mgmt" {
  name                      = "peer-hub-2-mgmt"
  resource_group_name       = azurerm_resource_group.rg-hub.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.mgmt-vnet.id 
  allow_forwarded_traffic = true
}
resource "azurerm_virtual_network_peering" "peer-mgmt-2-hub" {
  name                      = "peer-mgmt-2-hub"
  resource_group_name       = azurerm_resource_group.rg-mgmt.name
  virtual_network_name      = azurerm_virtual_network.mgmt-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id 
  allow_forwarded_traffic = true
}
resource "azurerm_virtual_network_peering" "peer-hub-2-vms" {
  name                      = "peer-hub-2-vms"
  resource_group_name       = azurerm_resource_group.rg-hub.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vms-vnet.id 
  allow_forwarded_traffic = true
}
resource "azurerm_virtual_network_peering" "peer-vms-2-hub" {
  name                      = "peer-vms-2-hub"
  resource_group_name       = azurerm_resource_group.rg-vms.name
  virtual_network_name      = azurerm_virtual_network.vms-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id 
  allow_forwarded_traffic = true
}

## Setup network watcher
resource "azurerm_network_watcher" "network-watcher-hub" {
  name = "nw-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet-we-${var.deploymentDetails.instanceNumber}"
  location = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "vnet"
  }
}

## Setup diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "nsg-hub" {
  name                        = "diag-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-nsg"
  target_resource_id          = azurerm_network_security_group.nsg-hub.id
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.law.id
  depends_on                  = [azurerm_network_security_group.nsg-hub]
  
  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled = true

    retention_policy {
      enabled =true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg-diag-shared" {
  name = "diag-shared-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-nsg"
  target_resource_id = azurerm_network_security_group.nsg-shared.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled = true

    retention_policy {
      enabled =true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg-diag-mgmt" {
  name = "diag-mgmt-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-nsg"
  target_resource_id = azurerm_network_security_group.nsg-mgmt.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled = true

    retention_policy {
      enabled =true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg-diag-vms" {
  name = "diag-vms-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-nsg"
  target_resource_id = azurerm_network_security_group.nsg-vms.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled = true

    retention_policy {
      enabled =true
    }
  }
}
