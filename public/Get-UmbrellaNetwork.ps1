function Get-UmbrellaNetwork {
    [CmdletBinding()]
    param (
        [string]$NetworkId,
        [switch]$Internal
    )
    
    begin {
        Get-UmbrellaKeys

        $headers = @{
            "Authorization" = "Basic $mgmtKey"
        }
    }
    
    process {
        if ($PSBoundParameters.Internal) {
            $url = "https://management.api.umbrella.com/v1/organizations/$orgId/internalnetworks"
            if ($PSBoundParameters.NetworkId) {
                $url += "/$NetworkId"
            }
        } elseif ($PSBoundParameters.NetworkId) {
            $url = "https://management.api.umbrella.com/v1/organizations/$orgId/networks/$NetworkId"
        } else {
            $url = "https://management.api.umbrella.com/v1/organizations/$orgId/networks"
        }
        
        $req = Invoke-RestMethod -Uri $url -Headers $headers   
    }
    
    end {
        return $req
    }
}