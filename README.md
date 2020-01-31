# PSUmbrella (wip)

Powershell module for administering Cisco Umbrella. 

This module serves as an api-wrapper for Cisco Umbrella. You need api keys/secrets for the relevant cmdlets.

They break down as follows:

Reporting API
```powershell
Search-Umbrella
```

Management API
```powershell
Get-UmbrellaNetwork
Get-UmbrellaRoamingClients
Get-UmbrellaSite
Get-UmbrellaVirtualAppliance
```

## Setup
Run the `Connect-Umbrella` cmdlet to set up the local config file which holds your keys/secrets and org id. These are all exported as SecureStrings and converted back to plaintext when calling a cmdlet.
```powershell 
Set-UmbrellaConfig -OrgId 1234567 -ReportKey 1234abcdefg -ReportSecret 1234abcdefg -NetworkKey 1234abcdefg -NetworkSecret 1234abcdefg -ManagementKey 1234abcdefg -ManagementSecret 1234abcdefg
```
Config is stored in `$env:APPDATA\psumbrella\umbrellaconfig.json`

## Examples
```powershell
# Get the last 5 calls to $domain 
Search-Umbrella -Domain google.com -Limit 5
```
