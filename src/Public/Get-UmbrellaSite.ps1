function Get-UmbrellaSite {
    [CmdletBinding()]
    param (
        [string]$SiteId
    )

    begin {
        Get-UmbrellaConfig

        $headers = @{
            "Authorization" = "Basic $apiKey"
        }
    }

    process {
        $url = "https://management.api.umbrella.com/v1/organizations/$orgId/sites"
        if ($PSBoundParameters.SiteId) {
            $url += "/$SiteId"
        }
        $req = Invoke-RestMethod -Uri $url -Headers $headers
        $res = $req | select @{n="ID";e={$_.originId}}, @{n="Default";e={$_.isDefault}}, @{n="Modified";e={$_.modifiedAt}}, @{n="Created";e={$_.createdAt}},
                             @{n="Type";e={$_.type}}, @{n="Internal Network Count";e={$_.internalNetworkCount}}, @{n="VA Count";e={$_.vaCount}}, @{n="Site ID";e={$_.siteId}}
    }

    end {
        return $res
    }
}