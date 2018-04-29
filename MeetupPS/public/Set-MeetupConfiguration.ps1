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
    .NOTES
        https://github.com/lazywinadmin/MeetupPS
    #>
    [CmdletBinding()]
    PARAM($ClientID,$Secret)
    TRY{
        $FunctionName = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand

        # Retrieve Code
        $Url = "https://secure.meetup.com/oauth2/authorize?client_id=$ClientID&response_type=code&redirect_uri=https://github.com/lazywinadmin/MeetupPS"
        Write-Verbose -Message "[$FunctionName] Querying Url = '$Url'"

        # Ask user to authenticate and return Code only
        $OAuthCode = Get-OauthCode -url $Url
        Write-Verbose -Message "[$FunctionName] Retrieving Code from '$OAuthCode'"
        $Code = ($OAuthCode -split "\?code=")[1]
        Write-Verbose -Message "[$FunctionName] Code '$Code'"

        # Retrieve Access Token
        Write-Verbose -Message "[$FunctionName] Querying Access Token with ClientID '$ClientId'"
        $script:MeetupAccessToken = Get-OAuthAccessToken -ClientID $clientID -Secret $Secret -Code $Code
    }Catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}