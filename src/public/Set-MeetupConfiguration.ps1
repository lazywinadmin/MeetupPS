function Set-MeetupConfiguration {
<#
.SYNOPSIS
    Authenticate against the Rest API
.DESCRIPTION
    Authenticate against the Rest API
.PARAMETER ClientID
    Specify the Key of the Oauth Consumer
.PARAMETER Secret
    Specify the Secret of the Oauth Consumer
.PARAMETER RedirectUri
    Specify the RedirectUri to use
.PARAMETER Scope
    Specify the scope
    Default are the following ("basic", "reporting", "event_management")
.EXAMPLE
    # Connect against Meetup.com API
    $Key = '<Your Oauth Consumer Key>'
    $Secret = '<Your Oauth Consumer Secret>'
    Set-MeetupConfiguration -ClientID $Key -Secret $Secret
.NOTES
    https://github.com/lazywinadmin/MeetupPS
#>
    [CmdletBinding()]
    PARAM(
        [Parameter(Mandatory=$true)]
        $ClientID,
        [Parameter(Mandatory = $true)]
        $Secret,
        $RedirectUri = 'https://github.com/lazywinadmin/MeetupPS',
        $Scope = ("basic", "reporting", "event_management")
        )
    TRY{
        $FunctionName = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand

        # Retrieve Code
        $Url = "https://secure.meetup.com/oauth2/authorize?client_id=$ClientID&response_type=code&redirect_uri=$RedirectUri"
        Write-Verbose -Message "[$FunctionName] Querying Url = '$Url'"

        # Ask user to authenticate and return Code only
        $OAuthCode = Get-OauthCode -url $Url
        Write-Verbose -Message "[$FunctionName] Retrieving Code from '$OAuthCode'"
        $Code = ($OAuthCode -split "\?code=")[1]
        Write-Verbose -Message "[$FunctionName] Code '$Code'"

        # Retrieve Access Token
        Write-Verbose -Message "[$FunctionName] Querying Access Token with ClientID '$ClientId'"
        $script:MeetupAccessToken = Get-OAuthAccessToken -ClientID $clientID -Secret $Secret -Code $Code -RedirectUri $RedirectUri -Scopes $Scope
    }Catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}