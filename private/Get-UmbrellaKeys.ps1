function Get-UmbrellaKeys {
    if (!(Test-Path -Path "$($env:AppData)\psumbrella\umbrellaconfig.json")) {
        Throw "PSUmbrella configuration file not found in `"$($env:AppData)\psumbrella\umbrellaconfig.json`", please run Connect-Umbrella to configure module settings."
    } else {
        $config = Get-Content "$($env:AppData)\psumbrella\umbrellaconfig.json" | ConvertFrom-Json
        $orgId = $config.org.id

        # management key
        $mgmtKeySecString = $config.keys.management | ConvertTo-SecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($mgmtKeySecString)
        $mgmtKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # report key
        $reportKeySecString = $config.keys.report | ConvertTo-SecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($reportKeySecString)
        $reportKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # network key
        $networkKeySecString = $config.keys.network | ConvertTo-SecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($networkKeySecString)
        $networkKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }

    $Script:orgId = $orgId
    $Script:mgmtKey = $mgmtKey
    $Script:reportKey = $reportKey
    $Script:networkKey = $networkKey
}