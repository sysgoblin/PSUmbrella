function Get-UmbrellaNetwork {
    [CmdletBinding()]
    param (
        [string]$NetworkId,
        [switch]$Internal
    )
    
    begin {
        if (!(Test-Path -Path "$($env:AppData)\psumbrella\umbrellaconfig.json")) {
            Throw "PSUmbrella configuration file not found in `"$($env:AppData)\psumbrella\umbrellaconfig.json`", please run Set-UmbrellaConfig to configure module settings."
        } else {
            $config = Get-Content "$($env:AppData)\psumbrella\umbrellaconfig.json" | ConvertFrom-Json
            $orgId = $config.org.id
            $apiKeySecString = $config.keys.management | ConvertTo-SecureString
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($apiKeySecString)
            $apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }

        $headers = @{
            "Authorization" = "Basic $apiKey"
        }
    }
    
    process {
        if ($PSBoundParameters.Internal) {
            $url = "https://management.api.umbrella.com/v1/organizations/$orgId/internalnetworks"
            if ($PSBoundParameters.NetworkId) {
                $url += "/$NetworkId"
            }
        } 

        if ($PSBoundParameters.NetworkId) {
            $url = "https://management.api.umbrella.com/v1/organizations/$orgId/networks/$NetworkId"
        } 
        
        if ($PSBoundParameters -eq $null) {
            $url = "https://management.api.umbrella.com/v1/organizations/$orgId/networks"
        }
        
        $req = Invoke-RestMethod -Uri $url -Headers $headers   
    }
    
    end {
        return $req
    }
}