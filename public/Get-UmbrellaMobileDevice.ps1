function Get-UmbrellaMobileDevice {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,
        [Parameter(ParameterSetName = 'Owner')]
        [string]$Owner,
        [Parameter(ParameterSetName = 'Email')]
        [string]$Email,
        [Parameter(ParameterSetName = 'SerialNumber')]
        [string]$SerialNumber,
        [Parameter(ParameterSetName = 'HostName')]
        [string]$HostName
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
            $url = "https://api.opendns.com/v3/organizations/$orgId/hydrapassthroughs"
            $allDevices = Invoke-RestMethod -Uri $url -WebSession $umbrellaSession -Headers $auth
        } catch {
            Remove-Variable umbrellaSession -Scope "Script"
            Throw "Unable to get data. Session may have expired, please try again"
        }

        switch ($PSCmdlet.ParameterSetName) {
            'All'           { $results = $allDevices }
            'Owner'         { $results = $allDevices.Where({$_.deviceOwner -match $Owner}) }
            'Email'         { $results = $allDevices.Where({$_.deviceEmail -match $Email}) }
            'SerialNumber'  { $results = $allDevices.Where({$_.serialNumber -match $SerialNumber}) }
            'HostName'      { $results = $allDevices.Where({$_.hostname -match $HostName}) }
        }
    }

    end {
        return $results
    }
}