function Get-UmbrellaSecuritySettings {
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
            $url = "https://api.opendns.com/v3/organizations/$orgId/securitysettings"
            $allSec = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'   { $results = $allSec }
            'Name'  {
                $id = $allSec.Where({$_.Name -eq $Name}).Id
                $url += "/$id"
                $results = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
            }
        }
    }

    end {
        return $results
    }
}