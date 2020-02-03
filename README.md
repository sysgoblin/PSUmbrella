# PSUmbrella (wip)

Powershell module for administering Cisco Umbrella.

This module serves as an api-wrapper for Cisco Umbrella. You need api keys/secrets for the relevant cmdlets.

They break down as follows:

Reporting API
```powershell
Search-Umbrella # Search umbrella activity
```

Management API
```powershell
Get-UmbrellaNetwork             # List of all networks linked with Umbrella
Get-UmbrellaRoamingClients      # List of all roaming clients and their status
Get-UmbrellaSite                # List of sites linked with Umbrella
Get-UmbrellaVirtualAppliance    # List of all VA's and their status
```

There is also an insane amount of data you can interact with from Umbrella which is not accessible via the provided API's. The below cmdlets are made possible by providing a set of log in credentials and are pretty hacky so be warned I accept no responsibility if you use these destructively. These will also likely break if Umbrella change how they provide xsrf tokens or change their cookie set up.
I'm writing up more info on how these work and what kind of data you can interact with.

Complete:
```powershell
Get-UmbrellaAccount                 # Get user account info
Get-UmbrellaApplication             # Get application(s) Umbrella allows you to block/allow
Get-UmbrellaApplicationSettings     # Get application settings for all or specified app setting policy
Get-UmbrellaBlockPage               # Get information of configured block pages
Get-UmbrellaContentCategory         # Returns content category settings. Enabled categories are returned in results for specific content category profile
Get-UmbrellaDestinationList         # List destination lists or get the destinations of specified destination list
Get-UmbrellaLinkedMDM               # Get info on MDM solutions linked with Umbrella (note this can include a lot of senstitive info)
Get-UmbrellaMobileDevice            # Get details of all mobile devices controlled by Umbrella (lots of info!!)
Get-UmbrellaPolicy                  # Get policy information. Use -Detailed for loads more info
Get-UmbrellaSecuritySettings        # Umbrella security settings and category selections
```

WIP:
```powershell
Get-UmbrellaIntegrations            #
Get-UmbrellaRequests                #
Set-UmbrellaAccount                 #
Set-UmbrellaBlockPage               #
Set-UmbrellaDestinationList         #
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
