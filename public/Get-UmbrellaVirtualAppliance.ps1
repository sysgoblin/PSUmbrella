function Get-UmbrellaVirtualAppliance {
    [CmdletBinding()]
    param (
        [string]$ApplianceId
    )
    
    begin {
        Get-UmbrellaKeys

        $headers = @{
            "Authorization" = "Basic $mgmtKey"
        }
    }
    
    process {
        $url = "https://management.api.umbrella.com/v1/organizations/$orgId/virtualappliances"
        if ($PSBoundParameters.ApplianceId) {
            $url += "/$ApplianceId"
        }
        $req = Invoke-RestMethod -Uri $url -Headers $headers   
    }
    
    end {
        return $req
    }
}