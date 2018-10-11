function Get-MeetupPhoto {
<#
.SYNOPSIS
    Retrieve photos for a specific Meetup group.
.PARAMETER GroupName
    Specify the name of the group.
.PARAMETER AlbumId
    Specify the unique identifier of a specific photo album.
.PARAMETER Page
    Number of photos to retrieve.
    Default is 200
.PARAMETER Descending
    Reverses the order in which returned photos are listed.
.EXAMPLE
    Get-MeetupPhoto -GroupName FrenchPSUG

    This command returns all of the French PowerShell User Group's photos.
.EXAMPLE
    Get-MeetupPhoto -GroupName FrenchPSUG -AlbumId 28555599

    This command returns only the photos from the specified album belonging to the French PowerShell User Group.
.EXAMPLE
    Get-MeetupPhotoAlbum -GroupName FrenchPSUG -Page 2 | Get-MeetupPhoto -GroupName FrenchPSUG

    This command returns only the photos from the first 2 albums belonging to the French PowerShell User Group.
.NOTES
    https://github.com/lazywinadmin/MeetupPS
#>
    [CmdletBinding()]
    PARAM(
        [Parameter(Mandatory = $true)]
        [string] $GroupName,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [uint64] $AlbumId,

        [int] $Page = 200,

        [switch] $Descending
    )
    BEGIN {
        $FunctionName = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand
    }
    PROCESS {
        TRY {
            if ($AlbumId) {
                $Url = "https://api.meetup.com/$GroupName/photo_albums/$AlbumId/photos?page=$Page"
            } else {
                $Url = "https://api.meetup.com/$GroupName/photos?page=$Page"
            }
            if ($Descending) {
                $Url = "$Url&desc=true"
            }
            Write-Verbose -Message "[$FunctionName] Querying Url = '$Url'"
            $Photos = invoke-restmethod -uri $Url -UseDefaultCredentials
            Write-Output -InputObject $Photos
        }
        catch {$PSCmdlet.ThrowTerminatingError($_)}
    }
}