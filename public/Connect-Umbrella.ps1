function Connect-Umbrella {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'Default')]
        [int]$OrgId,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'Report')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$ReportKey,

        [Parameter(Mandatory = $true,
        ParameterSetName = 'Report')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$ReportSecret,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'Network')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$NetworkKey,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'Network')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$NetworkSecret,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'Management')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$ManagementKey,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'Management')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$ManagementSecret,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'Credentials')]
        [Parameter(ParameterSetName = 'Default')]
        [pscredential]$Credentials
    )

    begin {
        if (!(Test-Path -Path "$($env:AppData)\psumbrella\umbrellaconfig.json")) {
            New-Item -Path "$($env:AppData)\psumbrella\umbrellaconfig.json" -Force
        } else {
            $currentConfig = Get-Content "$($env:AppData)\psumbrella\umbrellaconfig.json" | ConvertFrom-Json
            $orgId = $currentConfig.org.id
            $reportSecString = $currentConfig.keys.report
            $networkSecString = $currentConfig.keys.network
            $managementSecString = $currentConfig.keys.management
            $usernameSecString = $currentConfig.creds.username
            $passwordSecString = $currentConfig.creds.password
        }
    }

    process {
        if ($PSBoundParameters.ReportKey) {
            $reportApiKey = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$ReportKey`:$ReportSecret"))
            $reportApiKey = ConvertTo-SecureString $reportApiKey -AsPlainText -Force | ConvertFrom-SecureString
        } else {
            $reportApiKey = $reportSecString
        }

        if ($PSBoundParameters.NetworkKey) {
            $networkApiKey = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$networkKey`:$networkSecret"))
            $networkApiKey = ConvertTo-SecureString $networkApiKey -AsPlainText -Force | ConvertFrom-SecureString
        } else {
            $networkApiKey = $networkSecString
        }

        if ($PSBoundParameters.ManagementKey) {
            $managementApiKey = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$ManagementKey`:$ManagementSecret"))
            $managementApiKey = ConvertTo-SecureString $managementApiKey -AsPlainText -Force | ConvertFrom-SecureString
        } else {
            $managementApiKey = $managementSecString
        }

        if ($PSBoundParameters.Credentials) {
            $username = ConvertTo-SecureString $Credentials.UserName -AsPlainText -Force | ConvertFrom-SecureString
            $password = $Credentials.Password | ConvertFrom-SecureString
        } else {
            $username = $usernameSecString
            $password = $passwordSecString
        }

        $conf = @{
            "org" = @{
                "id" = "$orgId"
            }

            "keys" = @{
                "report"    = "$reportApiKey"
                "network"   = "$networkApiKey"
                "management" = "$managementApiKey"
            }

            "credentials" = @{
                "username" = "$username"
                "password" = "$password"
            }
        } | ConvertTo-Json
    }

    end {
        $conf | Out-File "$($env:AppData)\psumbrella\umbrellaconfig.json" -Force
    }
}