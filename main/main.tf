module "platform" {
  source = "../modules/aks"
  app_name = var.app_name
  aks = var.aks
}