function Get-OAuthAccessToken {
    <#
    .SYNOPSIS
        Retrieve Oauth Access Token
    .DESCRIPTION
        Retrieve Oauth Access Token
    .NOTES
        https://github.com/lazywinadmin/MeetupPS
    #>
    [CmdletBinding()]
    PARAM(
        $ClientID,
        $Secret,
        $Code,
        $RedirectUri = 'https://github.com/lazywinadmin/MeetupPS',
        $AccessUri = 'https://secure.meetup.com/oauth2/access',
        $Scopes = ("basic", "reporting", "event_management")
        )
    try {
        # Build Body
        $body = "client_id=$ClientID&client_secret=$Secret&grant_type=authorization_code&redirect_uri=$RedirectUri&code=$code"
        # Build Header
        $Headers = @{
            'X-OAuth-Scopes'          = $Scopes
            'X-Accepted-OAuth-Scopes' = $Scopes
        }

        # Build splatting
        $Splatting = @{
            Uri         = $AccessUri
            Method      = 'Post'
            ContentType = 'application/x-www-form-urlencoded'
            Body        = $Body
            headers     = $Headers
        }
        Invoke-RestMethod @Splatting
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}