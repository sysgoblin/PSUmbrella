function Get-UmbrellaConfig {

    if (!(Test-Path -Path "$($env:AppData)\psumbrella\umbrellaconfig.json")) {
        Throw "PSUmbrella configuration file not found in `"$($env:AppData)\psumbrella\umbrellaconfig.json`", please run Set-UmbrellaConfig to configure module settings."
    } else {
        $Script:config = Get-Content "$($env:AppData)\psumbrella\umbrellaconfig.json" | ConvertFrom-Json
        $Script:orgId = $config.org.id

        $apiKeySecString = $config.keys.report | ConvertTo-SecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($apiKeySecString)
        $Script:apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }
}