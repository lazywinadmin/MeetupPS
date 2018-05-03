
function Get-MeetupEventAttendance {
    <#
.SYNOPSIS
    Get the attendance of an event
.PARAMETER GroupName
    Specify GroupName
.PARAMETER ID
    Specify the Event ID
.EXAMPLE
    Get-MeetupEventAttendance -GroupName FrenchPSUG -id 232807877
.EXAMPLE
    Get-MeetupEvent -GroupName FrenchPSUG -Status past |select -first 5 |Get-MeetupEventAttendance
.NOTES
    https://github.com/lazywinadmin/MeetupPS

    #https://www.meetup.com/meetup_api/docs/:urlname/events/:id/attendance/#list
#>
    [Cmdletbinding()]
    PARAM(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $GroupName = "FrenchPSUG",

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('EventID')]
        $Id
    )
    PROCESS {
        try {
            $FunctionName = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand

            if (-not ($script:MeetupAccessToken)) {
                Write-Warning -Message 'You need to use Set-MeetupConfiguration first to authenticate against the Rest API'
            }

            #$PSCmdlet.MyInvocation.ExpectingInput
            IF ($PSCmdlet.MyInvocation.ExpectingInput) {
                $GroupName = $Groupname.group.urlname
                Write-Verbose -Message "[$FunctionName] GroupName '$GroupName' - Values from Pipeline"
            }
            ELSE {Write-Verbose -Message "[$FunctionName] GroupName '$GroupName' - Values from Parameters"}

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
}

