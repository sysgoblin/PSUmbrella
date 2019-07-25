function Search-Umbrella {
    [CmdletBinding()]
    param (
        [string]$Domain,
        [int]$Limit = 100
    )
    
    begin {
        if (!(Test-Path -Path "$($env:AppData)\psumbrella\umbrellaconfig.json")) {
            Throw "PSUmbrella configuration file not found in `"$($env:AppData)\psumbrella\umbrellaconfig.json`", please run Set-UmbrellaConfig to configure module settings."
        } else {
            $config = Get-Content "$($env:AppData)\psumbrella\umbrellaconfig.json" | ConvertFrom-Json
            $orgId = $config.org.id
            $apiKeySecString = $config.keys.report | ConvertTo-SecureString
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($apiKeySecString)
            $apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }

        $headers = @{
            "Authorization" = "Basic $apiKey"
        }
    }
    
    process {
        $url = "https://reports.api.umbrella.com/v1/organizations/$orgId/destinations/$domain/activity?limit=$limit"
        $req = Invoke-RestMethod -Uri $url -Headers $headers
        $res = $req.requests 
        $results = $res | select @{n="DateTime";e={[datetime]$_.dateTime -f 'dd/MM/yyyy hh:mm:ss'}}, @{n="Origin";e={$_.originLabel -replace '\s\(.*'}}, @{n="Internal IP";e={$_.internalIp}}, @{n="Categories";e={$_.categories}}, @{n="Status Code";e={$_.statusCode}}, @{n="Action";e={$_.actionTaken}}, @{n="Destination";e={$_.destination}}
    }
    
    end {
        return $results
    }
}