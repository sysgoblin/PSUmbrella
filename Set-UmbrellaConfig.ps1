function Set-UmbrellaConfig {
    [CmdletBinding()]
    param (
        [string]$Key,
        [string]$Secret,
        [int]$OrgId
    )
    
    if (!(Test-Path -Path "$($env:AppData)\psumbrella\umbrellaconfig.json")) {
        New-Item -Path "$($env:AppData)\psumbrella\umbrellaconfig.json" -Force
    } else {
        $apiKey = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$key`:$secret"))
        $apiKey = ConvertTo-SecureString $apiKey -AsPlainText -Force | ConvertFrom-SecureString

        $conf = @{
            "org" = @{
                "id" = "$orgId"
            }

            "keys" = @{
                "api"    = "$apiKey"
            }
        } | ConvertTo-Json

        $conf | Out-File "$($env:AppData)\psumbrella\umbrellaconfig.json" -Force
    }
}