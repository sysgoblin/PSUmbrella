function Get-UmbrellaControlledApplication {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,
        [Parameter(ParameterSetName = 'Name')]
        [string]$DisplayName,
        [Parameter(ParameterSetName = 'Email')]
        [string]$Email
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
            $url = "https://api.opendns.com/v3/organizations/$orgId/controlledapplications"
            $allAccounts = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            #Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'   { $results = $allAccounts }
            'Name'  { $results = $allAccounts.Where({$_.displayName -match $DisplayName}) }
            'Email' { $results = $allAccounts.Where({$_.email -match $Email}) }
        }
    }

    end {
        return $results
    }
}