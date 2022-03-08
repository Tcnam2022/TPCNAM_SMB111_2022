# Create a ressource group
az group create --name TpSmb111RG --location EastUS

# Create Vnet and subnets
az network vnet create --name myVNet --resource-group TpSmb111RG --location EastUS --address-prefixes 10.0.0.0/16 --subnet-name myFrontendSubnet --subnet-prefixes 10.0.1.0/24

az network vnet subnet create --name myBackendSubnet --resource-group TpSmb111RG --vnet-name MyVnet --address-prefixes 10.0.2.0/24

az network vnet subnet create --name AppService --resource-group TpSmb111RG --vnet-name MyVnet --address-prefixes 10.0.3.0/24


#Create public IP
az network public-ip create --name myPublicIPAddress --resource-group TpSmb111RG --allocation-method Static --sku Standard

#Create VMs
az vm create -n MyFrontendVM -g TpSmb111RG --image ubuntults --vnet-name MyVnet --subnet myFrontendSubnet --generate-ssh-keys --public-ip-address myPublicIPAddress

az vm create -n MyBackendVM -g TpSmb111RG --image ubuntults --vnet-name MyVnet --subnet myBackendSubnet --generate-ssh-keys --public-ip-address ""


# Create an App Service plan
az appservice plan create --name myAppServicePlanSmb111 --resource-group TpSmb111RG --sku P1V2

# Create a web app.
az webapp create --name MyWebAppSmb111 --resource-group TpSmb111RG --plan myAppServicePlanSmb111

# Webapp integration
az webapp vnet-integration add -g TpSmb111RG -n MyWebAppSmb111 --vnet MyVnet --subnet AppService