function Set-UmbrellaConfig {
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

        [Parameter(Mandatory = $true,
        ParameterSetName = 'Network')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$NetworkSecret,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'Management')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$ManagementKey,

        [Parameter(Mandatory = $true,
        ParameterSetName = 'Management')]
        [Parameter(ParameterSetName = 'Default')]
        [string]$ManagementSecret
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

        $conf = @{
            "org" = @{
                "id" = "$orgId"
            }

            "keys" = @{
                "report"    = "$reportApiKey"
                "network"   = "$networkApiKey"
                "management" = "$managementApiKey"
            }
        } | ConvertTo-Json

        $conf | Out-File "$($env:AppData)\psumbrella\umbrellaconfig.json" -Force
    }

    end {

    }
}