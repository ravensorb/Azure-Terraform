provider "azurerm" {
  features {}
}

data "azurerm_log_analytics_workspace" "law" {
  name = "law-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  resource_group_name = "rg-hub-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-law-${var.deploymentDetails.instanceNumber}"  
}

##Create Networking Resource Group for hub-spoke vnet
resource "azurerm_resource_group" "vnet-hub-rg" {
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

resource "azurerm_resource_group" "vnet-backup-rg" {
  name     = "rg-backup-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet-${var.deploymentDetails.instanceNumber}"
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

resource "azurerm_resource_group" "vnet-filesync-rg" {
  name     = "rg-filesync-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet-${var.deploymentDetails.instanceNumber}"
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

resource "azurerm_resource_group" "vnet-vms-rg" {
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
  resource_group_name = azurerm_resource_group.vnet-hub-rg.name
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
resource "azurerm_virtual_network" "backup-vnet" {
  name                = "vnet-backup-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet-backup-rg.name
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
resource "azurerm_virtual_network" "filesync-vnet" {
  name                = "vnet-filesync-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet-filesync-rg.name
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
  resource_group_name = azurerm_resource_group.vnet-vms-rg.name
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
  resource_group_name  = azurerm_resource_group.vnet-hub-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.2.0/28"]
}
resource "azurerm_subnet" "hub-snet-gateway" {
  name                 = "GatewaySubnet" ## Do not change
  resource_group_name  = azurerm_resource_group.vnet-hub-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.4.0/27"]
}
resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet" ## Do not change
  resource_group_name  = azurerm_resource_group.vnet-hub-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.3.0/26"]
}
resource "azurerm_subnet" "firewall-subnet" {
  name                 = "AzureFirewallSubnet" ##can also be AzureFirewallManagementSubnet
  resource_group_name  = azurerm_resource_group.vnet-hub-rg.name
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

resource "azurerm_monitor_diagnostic_setting" "vnet-backup-diag" {
  name                        = "diag-backup-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet"
  target_resource_id          = azurerm_virtual_network.backup-vnet.id
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.law.id
  depends_on                  = [azurerm_virtual_network.backup-vnet]
  
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

resource "azurerm_monitor_diagnostic_setting" "vnet-filesync-diag" {
  name                        = "diag-filesync-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet"
  target_resource_id          = azurerm_virtual_network.filesync-vnet.id
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.law.id
  depends_on                  = [azurerm_virtual_network.filesync-vnet]

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
  location            = azurerm_resource_group.vnet-hub-rg.location
  resource_group_name = azurerm_resource_group.vnet-hub-rg.name
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

resource "azurerm_network_security_group" "nsg-backup" {
  name                = "nsg-backup-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = azurerm_resource_group.vnet-backup-rg.location
  resource_group_name = azurerm_resource_group.vnet-backup-rg.name
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
resource "azurerm_network_security_group" "nsg-filesync" {
  name                = "nsg-filesync-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-${var.deploymentDetails.instanceNumber}"
  location            = azurerm_resource_group.vnet-filesync-rg.location
  resource_group_name = azurerm_resource_group.vnet-filesync-rg.name
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
  location            = azurerm_resource_group.vnet-vms-rg.location
  resource_group_name = azurerm_resource_group.vnet-vms-rg.name
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
resource "azurerm_virtual_network_peering" "peer-hub-2-backup" {
  name                      = "peer-hub-2-backup"
  resource_group_name       = azurerm_resource_group.vnet-hub-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.backup-vnet.id 
}
resource "azurerm_virtual_network_peering" "peer-backup-2-hub" {
  name                      = "peer-backup-2-hub"
  resource_group_name       = azurerm_resource_group.vnet-backup-rg.name
  virtual_network_name      = azurerm_virtual_network.backup-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id 
}
resource "azurerm_virtual_network_peering" "peer-hub-2-filesync" {
  name                      = "peer-hub-2-filesync"
  resource_group_name       = azurerm_resource_group.vnet-hub-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.filesync-vnet.id 
  allow_forwarded_traffic = true
}
resource "azurerm_virtual_network_peering" "peer-filesync-2-hub" {
  name                      = "peer-filesync-2-hub"
  resource_group_name       = azurerm_resource_group.vnet-filesync-rg.name
  virtual_network_name      = azurerm_virtual_network.filesync-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id 
  allow_forwarded_traffic = true
}
resource "azurerm_virtual_network_peering" "peer-hub-2-vms" {
  name                      = "peer-hub-2-vms"
  resource_group_name       = azurerm_resource_group.vnet-hub-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vms-vnet.id 
  allow_forwarded_traffic = true
}
resource "azurerm_virtual_network_peering" "peer-vms-2-hub" {
  name                      = "peer-vms-2-hub"
  resource_group_name       = azurerm_resource_group.vnet-vms-rg.name
  virtual_network_name      = azurerm_virtual_network.vms-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id 
  allow_forwarded_traffic = true
}

## Setup network watcher
resource "azurerm_network_watcher" "network-watcher-hub" {
  name = "nw-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-vnet-we-${var.deploymentDetails.instanceNumber}"
  location = azurerm_resource_group.vnet-hub-rg.location
  resource_group_name = azurerm_resource_group.vnet-hub-rg.name
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

resource "azurerm_monitor_diagnostic_setting" "nsg-diag-backup" {
  name = "diag-backup-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-nsg"
  target_resource_id = azurerm_network_security_group.nsg-backup.id
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

resource "azurerm_monitor_diagnostic_setting" "nsg-diag-filesync" {
  name = "diag-filesync-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-nsg"
  target_resource_id = azurerm_network_security_group.nsg-filesync.id
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

## Azure File Sync
resource "azurerm_resource_group" "filesync-rg" {
  name     = "rg-filesync-${var.deploymentDetails.env}-${var.deploymentDetails.locationPrefix}-storage-${var.deploymentDetails.instanceNumber}"
  location = var.location
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "filesync"
  }
}

resource "azurerm_storage_sync" "ss-filesync" {
  name = ""
  resource_group_name = azurerm_resource_group.filesync-rg
  location = azurerm_resource_group.filesync-rg.location
  incoming_traffic_policy = "AllowVirtualNetworksOnly"
  tags = {
    "CreatedBy"   = "${var.tagsStandard.createdBy}"
    "CreatedOn"   = "${var.tagsStandard.createdOn}"
    "CostCenter"  = "${var.tagsStandard.costCenter}"
    "Environment" = "${var.tagsStandard.environment}"
    "Critical"    = "${var.tagsStandard.critical}"
    "Location"    = "${var.location}"
    "Solution"    = "filesync"
  }
}