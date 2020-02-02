function Get-UmbrellaApplication {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,
        [Parameter(ParameterSetName = 'Name')]
        [string]$Name,
        [Parameter(ParameterSetName = 'Group')]
        [string]$GroupName
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
            $url = "https://api.opendns.com/v3/organizations/$orgId/applications"
            $allApps = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'   { $results = $allApps }
            'Name'  { $results = $allApps.Where({$_.Name -match $Name}) }
            'Group' { $results = $allApps.Where({$_.groupName -match $GroupName}) }
        }
    }

    end {
        return $results
    }
}