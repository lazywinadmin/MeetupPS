function Get-MeetupGroup {
<#
.SYNOPSIS
    Retrieve Meetup group information
.DESCRIPTION
    Retrieve Meetup group information
.PARAMETER GroupName
    Specify the name of the group name
.EXAMPLE
    Get-MeetupGroup -GroupName FrenchPSUG
.NOTES
    https://github.com/lazywinadmin/MeetupPS
#>
    [CmdletBinding()]
    PARAM(
        [Parameter(Mandatory = $true)]
        $GroupName)

    TRY {
        $FunctionName = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand

        $Url = "https://api.meetup.com/$GroupName"
        Write-Verbose -Message "[$FunctionName] Querying Url = '$Url'"
        $GroupObject = invoke-restmethod -uri $Url -UseDefaultCredentials

        Write-Output -InputObject $GroupObject
    }
    Catch {$PSCmdlet.ThrowTerminatingError($_)}
}