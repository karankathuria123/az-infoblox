@description('Security rules array')
param securityRules array

@description('Name of - Network Security Group')
param nsgName string

@description('Location of NSG')
param location string = resourceGroup().location

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-10-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      for rule in securityRules: {
        name: rule.name
        properties: union(
          {
            priority: rule.priority
            protocol: rule.protocol
            access: rule.access
            direction: rule.direction
          },
          empty(rule.sourcePortRanges) ? {} : { sourcePortRanges: rule.sourcePortRanges },
          empty(rule.sourcePortRange)  ? {} : { sourcePortRange: rule.sourcePortRange },
          empty(rule.sourceAddressPrefixes) ? {} : { sourceAddressPrefixes: rule.sourceAddressPrefixes },
          empty(rule.sourceAddressPrefix)  ? {} : { sourceAddressPrefix: rule.sourceAddressPrefix },
          empty(rule.destinationPortRanges) ? {} : { destinationPortRanges: rule.destinationPortRanges },
          empty(rule.destinationPortRange)  ? {} : { destinationPortRange: rule.destinationPortRange },
          empty(rule.destinationAddressPrefixes) ? {} : { destinationAddressPrefixes: rule.destinationAddressPrefixes },
          empty(rule.destinationAddressPrefix)  ? {} : { destinationAddressPrefix: rule.destinationAddressPrefix }
        )
      }
    ]
  }
}


output nsgId string = nsg.id
output nsgName string = nsg.name
