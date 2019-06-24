
function Get-MeetupGroupMember {
    <#
.SYNOPSIS
    Get the member of a meetup group
.PARAMETER GroupName
    Specify GroupName
.PARAMETER Page
    Number of requested members to return. Defaults to 200
.PARAMETER Order
    Orders results according to definitions listed below. May be one of "interesting", "name", "joined", or "stepup_recommended"
    -interesting
        Order which may be interesting to the authorized member
    -joined
        Time member joined this group
    -name
        The name of the member
    -stepup_recommended
        Sorts by likelikhood to step up as organizer
.EXAMPLE
    Get-MeetupGroupMember -Groupname FrenchPSUG
.EXAMPLE
    Get-MeetupGroupMember -Groupname FrenchPSUG -Page 500 -order joined
.NOTES
    https://github.com/lazywinadmin/MeetupPS

    https://www.meetup.com/meetup_api/docs/:urlname/members/#list
    # desc Boolean value controling sort order of results. Currently this parameter is only supported for "joined" and "name" sorted results. Defaults to true
    # fields A comma-delimited list of optional fields to append to the response
    # filter May be set to 'stepup_eligible' to return only members eligible to step up as organizer
    # order "interesting", "name", "joined", or "stepup_recommended"
    # page Number of requested members to return. Defaults to 200
    # role May be set to "leads" to filter returned members on the lead team
    # status A comma-delimited list of member statuses. Valid values include "active" or "pending". Defaults to "active". Organizers may request pending
#>
    [Cmdletbinding()]
    PARAM(
        [Parameter(Mandatory = $true)]
        $GroupName = "FrenchPSUG",
        [Alias('Limit')]
        $Page=200,
        [ValidateSet('interesting', 'name', 'joined', 'stepup_recommended')]
        $Order='joined'
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
            Uri     = "https://api.meetup.com/$GroupName/members?order=$order&page=$page"
        }

        Write-Verbose -Message "[$FunctionName] Querying API '$($Splat.uri)'..."
        (Invoke-RestMethod @splat)

    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

