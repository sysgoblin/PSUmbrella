function Get-UmbrellaContentCategory {
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
    }

    process {
        Get-UmbrellaTokens
        $auth = @{
            'authorization' = "Bearer $umbrellaToken"
        }

        try {
            $url = "https://api.opendns.com/v3/organizations/$orgId/categorysettings"
            $categories = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            # Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'   { $results = $categories | Select-Object -ExcludeProperty categoryBits }
            'Name'  {
                $id = ($categories.Where({$_.Name -eq $Name})).id
                $url += "/$id"
                $results = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
            }
        }
    }

    end {
        return $results
    }
}