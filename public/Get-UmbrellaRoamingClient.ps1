function Get-UmbrellaRoamingClient {
    [CmdletBinding()]
    param (
        [string]$ComputerId
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
    }
    
    process {
        if ($PSBoundParameters.ComputerId) {
            $url = "https://management.api.umbrella.com/v1/organizations/$orgId/roamingcomputers"
        } else {
            $url = "https://management.api.umbrella.com/v1/organizations/$orgId/roamingcomputers/$ComputerId"
        }

        $headers = @{
            "Authorization" = "Basic $apiKey"
        }

        $req = Invoke-RestMethod -Uri $url -Headers $headers
        $res = $req.requests 
    }
    
    end {
        return $res
    }
}