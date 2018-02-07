function Get-MeetupEvent
{
<#
.SYNOPSIS
    Retrieve Meetup event for a specific group
.PARAMETER GroupName
    Specify the name of the group
.PARAMETER Status
    Specify the status of the event(s).
    Values accepted: "cancelled", "draft", "past", "proposed", "suggested", "upcoming"
    Default is 'upcoming'.
.PARAMETER Page
    Number of entries to retrieve.
    Default is 200
.EXAMPLE
    Get-MeetupEvent -GroupName FrenchPSUG -Status past
.NOTES
    https://github.com/lazywinadmin/MeetupPS
#>
[CmdletBinding()]
PARAM(
    [Parameter(Mandatory=$true)]
    $GroupName,

    [ValidateSet("cancelled", "draft", "past", "proposed", "suggested", "upcoming")]
    $Status = 'upcoming',

    $page = 200

)

    $events = invoke-restmethod -uri "https://api.meetup.com/$GroupName/events?status=$Status&page=$page" -UseDefaultCredentials

    Write-Output -InputObject $events
}