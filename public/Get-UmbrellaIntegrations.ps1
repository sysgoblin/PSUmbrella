function Get-UmbrellaIntegrations {
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
            $url = "https://api.opendns.com/v3/organizations/$orgId/thirdpartyintegrations"
            $all = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'   { $results = $all }
            'Name'  {
                $id = $all.Where({$_.label -match $Name}).Id
                $url += "/$id"
                $int = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth

                $results = $int
            }
        }
    }

    end {
        return $results
    }
}