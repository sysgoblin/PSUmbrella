function Search-Umbrella {
    [CmdletBinding()]
    param (
        [string]$Domain,
        [int]$Limit = 100
    )

    begin {
        Get-UmbrellaConfig

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