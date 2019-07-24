function Search-Umbrella {
    [CmdletBinding()]
    param (
        [string]$Domain,
        [int]$Limit = 100
    )
    
    begin {
        if (!(Test-Path -Path "$($env:AppData)\psumbrella\umbrellaconfig.json")) {
            Throw "PSHornbill configuration file not found in `"$($env:AppData)\psumbrella\umbrellaconfig.json`", please run Set-HornbillConfig to configure module settings."
        } else {
            $config = Get-Content "$($env:AppData)\psumbrella\umbrellaconfig.json" | ConvertFrom-Json
            $orgId = $config.org.id
            $apiKeySecString = $config.keys.api | ConvertTo-SecureString
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($apiKeySecString)
            $apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }
    }
    
    process {
        $url = "https://reports.api.umbrella.com/v1/organizations/$orgId/destinations/$dest/activity?limit=$limit"
        $headers = @{
            "Authorization" = "Basic $apiKey"
        }
        $req = Invoke-RestMethod -Uri $url -Headers $headers
        $res = $req.requests | select 

        $results = $res | select @{n="Origin";e={$_.originLabel}}, @{n="Internal IP";e={$_.internalIp}}, @{n="Categories";e={$_.categories}}, @{n="Status Code";e={$_.statusCode}}, @{n="Action";e={$_.actionTaken}}, @{n="Destination";e={$_.destination}}
    }
    
    end {
        return $results
    }
}