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

There is also an insane amount of data you can interact with from Umbrella which is not accessible via the provided API's. The below cmdlets are made possible by providing a set of log in credentials and are pretty hacky so be warned I accept no responsibility if you use these destructively. These will also likely break if Umbrella change how they provide xsrf tokens or change their cookie set up.
I'm writing up more info on how these work and what kind of data you can interact with.

Complete:
```powershell
Get-UmbrellaMobileDevice
Get-UmbrellaPolicy
```

WIP:
```powershell
Get-UmbrellaApplicationSettings
Get-UmbrellaBlockPage
Get-UmbrellaContentCategory
Get-UmbrellaDashboard
Get-UmbrellaDestinationList
Get-UmbrellaIntegrations
Get-UmbrellaLinkedMDM
Get-UmbrellaMessages
Get-UmbrellaRequests
Get-UmbrellaRootCert
Get-UmbrellaSecuritySettings
Set-UmbrellaAccount
Set-UmbrellaBlockPage
Set-UmbrellaDestinationList
```

## Setup
Run the `Connect-Umbrella` cmdlet to set up the local config file which holds your keys/secrets and org id. These are all exported as SecureStrings and converted back to plaintext when calling a cmdlet.
```powershell
Connect-Umbrella -OrgId 1234567 -ReportKey 1234abcdefg -ReportSecret 1234abcdefg -NetworkKey 1234abcdefg -NetworkSecret 1234abcdefg -ManagementKey 1234abcdefg -ManagementSecret 1234abcdefg -Credentials $credsObject
```
Config is stored in `$env:APPDATA\psumbrella\umbrellaconfig.json`

## Examples
```powershell
# Get the last 5 calls to $domain
Search-Umbrella -Domain google.com -Limit 5
```
