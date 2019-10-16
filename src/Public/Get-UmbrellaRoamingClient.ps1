function Get-UmbrellaRoamingClient {
    [CmdletBinding()]
    param (
        [string]$ComputerId
    )

    begin {
        Get-UmbrellaConfig
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