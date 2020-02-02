function Get-UmbrellaApplicationSettings {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,
        [Parameter(ParameterSetName = 'Name')]
        [string]$Name
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
            $url = "https://api.opendns.com/v3/organizations/$orgId/applicationsettings"
            $allApps = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'   { $results = $allApps }
            'Name'  {
                $id = $allApps.Where({$_.Name -match $Name}).Id
                $url += "/$id"
                $app = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth

                $results = $app
            }
        }
    }

    end {
        return $results
    }
}