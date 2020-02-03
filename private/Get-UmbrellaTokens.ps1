function Get-UmbrellaTokens {
    # get xsrf token
    $r = Invoke-WebRequest -Uri "https://dashboard.umbrella.com/o/$orgId/" -WebSession $umbrellaSession -UseBasicParsing
    $xsrf = [regex]::Match($r.RawContent, '"csrf_token":"([^"]*)')
    $xsrf = $xsrf.Groups[1].Value

    # get bearer token
    $headers = @{
        'x-csrf-token' = $xsrf
    }
    $r = Invoke-RestMethod -Uri "https://dashboard.umbrella.com/token" -WebSession $umbrellaSession -Headers $headers -UseBasicParsing
    $bearerToken = $r.token

    $script:umbrellaToken = $bearerToken
}