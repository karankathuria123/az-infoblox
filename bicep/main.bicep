@description('Array of VM Configurations')
param vmConfigs array

@description('Array of NSG Rules')
param securityRules array

@description('Location for all resources')
param location string = resourceGroup().location

@description('Subnet Resource ID')
param subnetID string

@description('Common VM Size')
param vmSize string = 'Standard_D2s_v5'

@description('OS Type')
param osType string = 'linux'

// Depoy NSG for each VM
module nsgs 'modules/nsg.bicep' = {
    name: 'nsg-deployment-${location}'
    params: {
      nsgName: 'nsg-${location}'
      location: location
      securityRules: securityRules
    }
  }

//Deploy NICs for each VM
module nics 'modules/nic.bicep' = [
  for (config, i) in vmConfigs: {
    name: 'nic-deployment-${config.vmName}'
    params: {
      nicName: '${config.vmName}-nic'
      location: location
      subnetID: subnetID
      nsgID: nsgs.outputs.nsgId
      privateIPAddress: config.privateIP
      enableAcceleratedNetworking: config.enableAcceleratedNetworking
    }
  }
]

//Deploy vNIOS
module vms 'modules/vm.bicep' = [
  for (config, i) in vmConfigs: {
    name: 'vm-deployment-${config.vmName}'
    params: {
      vNIOSNAME: config.vmName
      location: location
      vmSize: vmSize
      osType: osType
      nicId: nics[i].outputs.nicID
      OSdiskID: config.osDiskId
    }
    dependsOn: [
      nics[i]
    ]
  }
]

output vmNames array = [for (config, i) in vmConfigs: vms[i].outputs.vmName]
output VMIds array = [for (config, i) in vmConfigs: vms[i].outputs.vmId]
