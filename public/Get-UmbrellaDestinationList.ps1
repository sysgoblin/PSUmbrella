function Get-UmbrellaDestinationList {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,
        [Parameter(Mandatory = $true, ParameterSetName = 'Name')]
        [string]$Name,
        [Parameter(Mandatory = $false, ParameterSetName = 'Name')]
        [switch]$Destinations
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
            $url = "https://api.opendns.com/v3/organizations/$orgId/destinationlists"
            $allDest = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'   { $results = $allDest }
            'Name'  {
                if ($PSBoundParameters.Destinations) {
                    $id = $allDest.Where({$_.Name -eq $Name}).Id
                    $i = 0
                    $lastResult = 100
                    $results = @()
                    while ($lastResult -eq 100) {
                        $i++
                        $url = "https://api.opendns.com/v3/organizations/$orgId/destinationlists/$id/destinations?page=$i&limit=100"
                        $res = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
                        $lastResult = $res.count
                        $results += $res
                    }
                } else {
                    $results = $allDest.Where({$_.Name -eq $Name})
                }
            }
        }
    }

    end {
        return $results
    }
}