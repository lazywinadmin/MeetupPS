function Get-MeetupGroup
{
<#
.SYNOPSIS
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
    [Parameter(Mandatory=$true)]
    $GroupName)

    $GroupObject = invoke-restmethod -uri "https://api.meetup.com/$GroupName" -UseDefaultCredentials

    Write-Output -InputObject $GroupObject
}