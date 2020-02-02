function Get-UmbrellaPolicy {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,
        [Parameter(ParameterSetName = 'Name')]
        [string]$Name,

        [switch]$Detailed
    )

    begin {
        if (!($umbrellaSession)) {
            Get-UmbrellaSession
        }
        Get-UmbrellaTokens
        $auth = @{
            'authorization' = "Bearer $umbrellaToken"
        }
    }

    process {
        try {
            $url = "https://api.opendns.com/v3/organizations/$orgId/bundles"
            if ($PSBoundParameters.Detailed) {
                $url += '?sort={"isDefault":"asc","priority":"asc"}&optionalFields=["categorySetting","fileInspectionSetting","policySetting","securitySetting","identityCount","domainlists","settingGroupBypassInspectionGroup"]&outputFormat=json'
            }
            $allPolicies = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'           { $results = $allPolicies }
            'Name'         { $results = $allPolicies.Where({$_.Name -match $Name}) }
        }
    }

    end {
        return $results
    }
}