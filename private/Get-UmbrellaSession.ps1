function Get-UmbrellaSession {
    if (!(Test-Path -Path "$($env:AppData)\psumbrella\umbrellaconfig.json")) {
        Throw "PSUmbrella configuration file not found in `"$($env:AppData)\psumbrella\umbrellaconfig.json`", please run Connect-Umbrella to configure module settings."
    } else {
        try {
            $config = Get-Content "$($env:AppData)\psumbrella\umbrellaconfig.json" | ConvertFrom-Json
            $orgId = $config.org.id

            # username
            $userSecString = $config.Credentials.username | ConvertTo-SecureString
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($userSecString)
            $user = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

            # password
            $passwordSecString = $config.Credentials.password | ConvertTo-SecureString
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecString)
            $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        } catch {
            Throw "No credentials within PSUmbrella config. Please run Connect-Umbrella and provide a credential object."
        }
    }

    # validate session
    $login = Invoke-WebRequest -Uri "https://login.umbrella.com/umbrella" -SessionVariable session
    # write test to validate this form
    $form = $login.Forms[0]
    $form.fields['username'] = $user
    $form.fields['password'] = $password

    $login = Invoke-WebRequest -WebSession $session -Uri "https://login.umbrella.com/umbrella" -Method Post -Body $form.Fields -UseBasicParsing


    # set cookie for opendns.com because iwr session variables suck serious shit
    $umbCookie = $session.Cookies.GetCookies("https://umbrella.com")
    $cookie = New-Object System.Net.Cookie
    $cookie.Name = $umbCookie.Name # Add the name of the cookie
    $cookie.Value = $umbCookie.Value # Add the value of the cookie
    $cookie.Domain = "api.opendns.com"
    $cookie.HttpOnly = $umbCookie.HttpOnly
    $cookie.Expires = $umbCookie.Expires
    $cookie.Path = $umbCookie.Path
    $cookie.Secure = $umbCookie.Secure

    $session.Cookies.Add($cookie)

    $Script:umbrellaSession = $session
    $Script:orgId = $orgId
}