
function Get-MeetupEventAttendance {
<#
.SYNOPSIS
    Get the attendance of an event
.PARAMETER GroupName
    Specify GroupName
.PARAMETER ID
    Specify the Event ID
.EXAMPLE
    Get-MeetupGroupMember -Groupname FrenchPSUG -Page 500 -order joined
.NOTES
    https://github.com/lazywinadmin/MeetupPS

    #https://www.meetup.com/meetup_api/docs/:urlname/events/:id/attendance/#list

#>
    [Cmdletbinding()]
    PARAM(
        [Parameter(Mandatory = $true)]
        $GroupName = "FrenchPSUG",
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('EventID')]
        $Id
    )
    try {
        $FunctionName = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand

        if (-not ($script:MeetupAccessToken)) {
            Write-Warning -Message 'You need to use Set-MeetupConfiguration first to authenticate against the Rest API'
        }

        Write-Verbose -Message "[$FunctionName] Prepare Splatting"
        $Splat = @{
            Headers = @{Authorization = 'Bearer ' + $($script:MeetupAccessToken.access_token)}
            Method  = 'GET'
            Uri     = "https://api.meetup.com/$GroupName/events/$id/attendance"
        }

        Write-Verbose -Message "[$FunctionName] Querying API '$($Splat.uri)'..."
        (Invoke-RestMethod @splat)

    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

