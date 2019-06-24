
function New-MeetupEvent {
<#
.SYNOPSIS
    Create a Meetup event
.DESCRIPTION
    Create a Meetup event
.PARAMETER GroupName
    Specify GroupName
.PARAMETER Title
    Specify the Title of the event
.PARAMETER Time
    Specify the date and time to the event
    This will take the local time of the event.
.PARAMETER Description
    Specify the Description of the event
.PARAMETER Announce
    Specify this switch to announce the event to your group members
.PARAMETER PublishStatus
    Specify the Publish status of the event.
    Values accepted: draft or published
.EXAMPLE
    New-MeetupEvent `
        -GroupName FrenchPSUG `
        -Title 'New Event from MeetupPS' `
        -Time '2018/06/01 3:00pm' `
        -Description "PowerShell WorkShop<br><br>In this session we'll talk about ..." `
        -PublishStatus draft
.NOTES
    https://github.com/lazywinadmin/MeetupPS
#>
    [Cmdletbinding()]
    PARAM(
        [Parameter(Mandatory = $true)]
        $GroupName = "FrenchPSUG",

        [Parameter(Mandatory = $true)]
        $Title,

        $Time,

        $Description = "Description:<br><br>New Event from MeetupPS PowerShell module<br><br>Speaker:<br>",

        [switch]$Announce = $false,

        [ValidateSet('draft', 'published')]
        $PublishStatus = 'draft'
    )
    try {
        $FunctionName = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand

        if (-not ($script:MeetupAccessToken)) {
            Write-Warning -Message 'You need to use Set-MeetupConfiguration first to authenticate against the Rest API'
        }

        Write-Verbose -Message "[$FunctionName] Format date to unix time"
        $Time = Get-Date -date ((Get-Date -Date $Time).ToUniversalTime()) -UFormat %s

        # Append Trailing Zeros (it needs to be 13 digits
        if ($Time.Length -lt 13) {
            $diff = 13 - $Time.Length
            $Time = "{0}{1:$('0'*$diff)}" -f $Time, 0
        }

        Write-Verbose -Message "[$FunctionName] Prepare Splatting"
        $Splat = @{
            Headers = @{Authorization = 'Bearer ' + $($script:MeetupAccessToken.access_token)}
            Method  = 'POST'
            Uri     = "https://api.meetup.com/2/event"
            Body    = "group_urlname=$groupName&name=$Title&time=$Time&publish_status=$PublishStatus&announce=$Announce&description=$description"
        }

        Write-Verbose -Message "[$FunctionName] Creating Event..."
        Invoke-RestMethod @splat

    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}