function Get-UmbrellaActivity {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,
        [Parameter(ParameterSetName = 'Name')]
        [string]$DisplayName,
        [Parameter(ParameterSetName = 'Email')]
        [string]$Email,

        [int]$Limit,
        [datetime]$Start = (Get-Date).AddHours(-24),
        [datetime]$End = (Get-Date)
    )

    begin {
        if (!($umbrellaSession)) {
            Get-UmbrellaSession
        }
    }

    process {
        try {
            Get-UmbrellaTokens
        } catch {
            Get-UmbrellaSession
        }

        $auth = @{
            'authorization' = "Bearer $umbrellaToken"
        }

        # date time ranges
        $Start = [math]::Floor((Get-Date $Start -UFormat %s))
        $End = [math]::Floor((Get-Date $End -UFormat %s))

        $filters = @{
            "start" = $Start
            "end" = $End
        } | ConvertTo-Json

        try {
            $url = "https://api.opendns.com/v3/organizations/$orgId/reports/activity-all?filters=$filters&limit=5000"
            $all = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            # Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'   { $results = $all }
            'Name'  { $results = $all.Where({$_.displayName -match $DisplayName}) }
            'Email' { $results = $all.Where({$_.email -match $Email}) }
        }
    }

    end {
        return $results
    }
}