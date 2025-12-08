@description('Name of the vNIOS')
param vNIOSNAME string

@description('Location of the VM')
param location string = resourceGroup().location

@description('VM Size (Type)')
param vmSize string = 'Standard_D2s_v5'

@description('OS Type - Windows or Linux')
param osType string = 'linux'

@description('Network Interface Card for VM')
param nicId string

@description('Managed disk resource ID to attach as OS disk')
param OSdiskID string

resource vm 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: vNIOSNAME
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        osType: osType
        createOption: 'Attach'
        managedDisk: {
          id: OSdiskID
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

output vmId string = vm.id
output vmName string = vm.name
