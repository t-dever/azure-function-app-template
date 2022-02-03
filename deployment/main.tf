resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  allow_blob_public_access = true
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "application_insights" {
  name                = var.app_insights_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key

  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.aviatrix_controller_identity.id]
  # }

  os_type = "linux"
  version = "~4"

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"  = azurerm_application_insights.application_insights.instrumentation_key,
    "AzureWebJobsStorage"             = azurerm_storage_account.storage_account.primary_blob_connection_string,
    "SCM_DO_BUILD_DURING_DEPLOYMENT"  = "true",
    "PYTHON_ENABLE_WORKER_EXTENSIONS" = "1"
    "ENABLE_ORYX_BUILD"               = "true",
    "FUNCTIONS_WORKER_PROCESS_COUNT"  = "5"
    "FUNCTIONS_WORKER_RUNTIME"        = "python"
  }

  site_config {
    linux_fx_version = "Python|3.9"
    ftps_state       = "Disabled"
  }
}