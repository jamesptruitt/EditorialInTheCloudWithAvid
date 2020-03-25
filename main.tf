#############################
# Locals:(Non-Tradional)    #
# Please change the values  # 
# in this section to        #
# customize the setup for   # 
# environment               #
#############################
locals {
  resource_group_name               = "mytest"
  location                          = "westus2"
  admin_username                    = "azureuser"
  admin_password                    = "Password12345"
  address_space                     = "10.0.0.0/16"
  subnet_prefixes                   = ["10.0.1.0/24"]
  dns_servers                       = []
  subnet_names                      = ["default"]
  source_address_prefix             = "*"
  mediacomposer_vm_size             = "Standard_NV12"
  mediacomposer_vm_instances        = 2
  mediacomposer_vm_number_public_ip = 0
  mediacomposer_vm_public_ip_dns    = []
  #nexis_vm_size                    = "Standard_DS4_V2"
  #nexis_instances                  = 0
  #nexis_storage_vm_public_ip_dns   = ["nx00-${random_string.general.result}"]
  #nexis_type                       = "CloudNearline" # options "CloudNearline" or "CloudOnline"
  #mediaworker_vm_size              = "Standard_DS4_V2"
  #mediaworker_vm_instances         = 0
  #mediaworker_vm_public_ip_dns     = ["mw00-${random_string.general.result}","mw01-${random_string.general.result}"]
  #media_central_vm_size            = "Standard_DS4_V2"
  #media_central_vm_instances       = 0
  #media_central_vm_public_ip_dns   = []
  azureTags = {
                "environment" = "dev"
              }
}

#############################
# Resources                 #
#############################
module "editorial_networking" {
  source              = "./modules/azurenetwork"
  vnet_name           = "${local.resource_group_name}-vnet" 
  resource_group_name = "${local.resource_group_name}-${random_string.general.result}-rg" 
  location            = local.location
  address_space       = local.address_space
  dns_servers         = local.dns_servers
  subnet_prefixes     = local.subnet_prefixes
  subnet_names        = local.subnet_names
  allow_rdp_traffic   = true  
  allow_ssh_traffic   = true  
  sg_name             = "${local.resource_group_name}-secgrp"
  tags                = local.azureTags
}

locals {
  stored_resource_group_name      = module.editorial_networking.azurerm_resource_group_name
  stored_resource_group_location  = module.editorial_networking.azurerm_resource_group_location
  stored_subnet_id                = module.editorial_networking.azurerm_subnet_ids[0]
}

module "media_composer_deployment" {
  source                            = "./modules/mediacomposer"
  hostname                          = "mcomposer"
  admin_username                    = local.admin_username
  admin_password                    = local.admin_password
  resource_group_name               = local.stored_resource_group_name
  resource_group_location           = local.stored_resource_group_location
  subnet_id                         = local.stored_subnet_id
  source_address_prefix             = local.source_address_prefix
  mediacomposer_vm_size             = local.mediacomposer_vm_size
  mediacomposer_vm_instances        = local.mediacomposer_vm_instances
  mediacomposer_vm_number_public_ip = local.mediacomposer_vm_number_public_ip
  mediacomposer_vm_public_ip_dns    = local.mediacomposer_vm_public_ip_dns
  tags                              = local.azureTags
}

/*
module "nexis_deployment" {
  source                            = "./modules/nexis"
  hostname                          = "nexis"
  admin_password                    = local.admin_password
  resource_group_name               = local.stored_resource_group_name
  resource_group_location           = local.stored_resource_group_location
  subnet_id                         = local.stored_subnet_id
  source_address_prefix             = local.source_address_prefix
  nexis_storage_type                = local.nexis_type
  nexis_storage_vm_size             = local.nexis_vm_size
  nexis_storage_vm_instances        = local.nexis_instances
  nexis_storage_vm_number_public_ip = local.nexis_instances
  nexis_storage_vm_public_ip_dns    = local.nexis_storage_vm_public_ip_dns
  tags                              = local.azureTags
}

module "media_worker_deployment" {
  source                          = "./modules/mediaworker"
  hostname                        = "mworker"
  admin_username                  = local.admin_username
  admin_password                  = local.admin_password
  resource_group_name             = local.stored_resource_group_name
  resource_group_location         = local.stored_resource_group_location
  subnet_id                       = local.stored_subnet_id
  source_address_prefix           = local.source_address_prefix
  mediaworker_vm_size             = local.mediaworker_vm_size
  mediaworker_vm_instances        = local.mediaworker_vm_instances
  mediaworker_vm_number_public_ip = local.mediaworker_vm_instances
  mediaworker_vm_public_ip_dns    = local.mediaworker_vm_public_ip_dns
  tags                            = local.azureTags
}

module "media_central_deployment" {
  source                            = "./modules/mediacentral"
  hostname                          = "mcentral"
  admin_username                    = local.admin_username
  admin_password                    = local.admin_password
  resource_group_name               = local.stored_resource_group_name
  resource_group_location           = local.stored_resource_group_location
  subnet_id                         = local.stored_subnet_id
  source_address_prefix             = local.source_address_prefix
  media_central_vm_size             = local.media_central_vm_size
  media_central_vm_instances        = local.media_central_vm_instances
  media_central_vm_number_public_ip = local.media_central_vm_instances
  media_central_vm_public_ip_dns    = local.media_central_vm_public_ip_dns
  tags                              = local.azureTags
}
*/