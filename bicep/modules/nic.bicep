@description('Name of the network interfaces')
param nicName string

@description('location of the nic')
param location string = resourceGroup().location

@description('Subnet resource ID')
param subnetID string

@description('Network Security Group ID')
param nsgID string

@description('Private IP address')
param privateIPAddress string

@description('Enable accelerated networking')
param enableAcceleratedNetworking bool = false

resource nic 'Microsoft.Network/networkInterfaces@2024-10-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetID
          }
          privateIPAllocationMethod: 'Static'
          privateIPAddress: privateIPAddress
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgID
    }
    enableAcceleratedNetworking: enableAcceleratedNetworking
  }
}

output nicID string = nic.id
output nicName string = nic.name
