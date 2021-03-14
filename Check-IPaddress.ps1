Function Check-IPaddress {

<#
.SYNOPSIS
Check if ip addresses belong to the same network.
.DESCRIPTION
Check-IPaddress uses band to perform binary comparison of ip addresses and network mask to identify if ip adderesses belong to the same network. 
.PARAMETER ip_address_1
Specifies the IPv4 
.PARAMETER ip_address_2
Specifies the IPv4
.PARAMETER network_mask
Specifies values in decimal format
.EXAMPLE
Check-IPaddress -ip_address_1 192.168.0.1 -ip_address_2 192.168.0.2 -network_mask 255.255.255.0

#>

[cmdletbinding()]
Param(
[parameter(Mandatory=$true,ValueFromPipeline=$True)]
[IPAddress]$ip_address_1,
[parameter(Mandatory=$true,ValueFromPipeline=$True)]
[IPAddress]$ip_address_2,
[parameter(Mandatory=$true,ValueFromPipeline=$True)]
[IPAddress]$network_mask

)

Process{
 
 if (($ip_address_1.Address -band $network_mask.Address) -eq ($ip_address_2.Address -band $network_mask.Address))
 #We use property  address property of System.Net.IPAddress. -band to compare numbers on bit level
 {Write-Verbose "The ip addresses are in the same network"}
 else{
  Write-Verbose "The ip addresses are not in the different networks"
  }



}


}

Check-IPaddress -Verbose


#Using regex pattern validation and binary operators

[cmdletbinding()]
Param(
[Parameter(Mandatory)]
[ValidateScript(
{If ($_ -match '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
            $True
        } Else {
            Throw "$_ is not valid IPV4 Address!"
        }})]
[string]$ip_address_1,
[Parameter(Mandatory)]
[ValidateScript(
{If ($_ -match '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
            $True
        } Else {
            Throw "$_ is not valid IPV4 Address!"
        }})]
[string]$ip_address_2,
[Parameter(Mandatory)]
[ValidateScript(
{If ($_ -match '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
            $True
        } Else {
            Throw "$_ is not valid IPV4 Address!"
        }})]
[string]$network_mask

)

Begin{
$ip1array = [uint32[]]$ip_address_1.split(‘.’) #create an array
[uint32] $uip_address_1 = ($ip1array[0] -shl 24) + ($ip1array[1] -shl 16) + ($ip1array[2] -shl 8) + $ip1array[3]#converting to [uint32] using shift bits left
$ip2array=[uint32[]]$ip_address_2.split(‘.’)
[uint32] $uip_address_2 = ($ip2array[0] -shl 24) + ($ip2array[1] -shl 16) + ($ip2array[2] -shl 8) + $ip2array[3]
$netmaskarray=[uint32[]]$network_mask.split(‘.’) 
[uint32] $unetworkmask = ($netmaskarray[0] -shl 24) + ($netmaskarray[1] -shl 16) + ($netmaskarray[2] -shl 8) + $netmaskarray[3]

}

Process{

if (($uip_address_1 -band $unetworkmask) -eq ($uip_address_2 -band $unetworkmask))
 {Write-Verbose "The ip addresses are in the same network"}
 else{
  Write-Verbose "The ip addresses are not in the different networks"
  }


}
