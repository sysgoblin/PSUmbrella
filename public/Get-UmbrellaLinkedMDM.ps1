function Get-UmbrellaLinkedMDM {
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
            $url = "https://api.opendns.com/v3/organizations/$orgId/mdmpassthroughs"
            if ($PSBoundParameters.Name) {
                $data = "{`"method`":`"GET`",`"path`":`"mdms/$Name`"}"
            } else {
                $data = "{`"method`":`"GET`",`"path`":`"mdms/`"}"
            }
            $MDM = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth -Method Post -Body $data
        } catch {
            Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        $results = $MDM
    }

    end {
        return $results
    }
}