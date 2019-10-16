function Get-UmbrellaNetwork {
    [CmdletBinding()]
    param (
        [string]$NetworkId,
        [switch]$Internal
    )

    begin {
        Get-UmbrellaConfig

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