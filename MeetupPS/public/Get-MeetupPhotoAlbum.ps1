function Get-MeetupPhotoAlbum {
<#
.SYNOPSIS
    Retrieve photo albums for a specific Meetup group.
.PARAMETER GroupName
    Specify the name of the group.
.PARAMETER AlbumId
    Specify the unique identifier of a specific photo album.
.PARAMETER Page
    Number of entries to retrieve.
    Default is 200.
    Cannot be used in conjunction with AlbumId.
.PARAMETER Offset
    Offsets the number of entries to return for pagination in conjunction with Page.
    Cannot be used in conjunction with AlbumId.
.EXAMPLE
    Get-MeetupPhotoAlbum -GroupName FrenchPSUG

    This command returns all of the French PowerShell User Group's photo albums.
.EXAMPLE
    Get-MeetupPhotoAlbum -GroupName FrenchPSUG -AlbumId 28555599

    This command returns only the specified photo album belonging to the French PowerShell User Group.
.NOTES
    https://github.com/lazywinadmin/MeetupPS
#>
    [CmdletBinding(DefaultParameterSetName = 'AllAlbums')]
    PARAM(
        [Parameter(Mandatory = $true)]
        [string] $GroupName,

        [Parameter(Mandatory = $true,
                   ParameterSetName = 'SpecificAlbum')]
        [Alias('Id')]
        [uint64] $AlbumId,

        [Parameter(ParameterSetName = 'AllAlbums')]
        [int] $Page = 200,

        [Parameter(ParameterSetName = 'AllAlbums')]
        [int] $Offset
    )
    TRY {
        $FunctionName = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand
        if ($AlbumId) {
            $Url = "https://api.meetup.com/$GroupName/photo_albums/$AlbumId"
        } else {
            $Url = "https://api.meetup.com/$GroupName/photo_albums?page=$Page"
            if ($Offset) {
                $Url = "$Url&offset=$Offset"
            }
        }
        Write-Verbose -Message "[$FunctionName] Querying Url = '$Url'"
        $Albums = invoke-restmethod -uri $Url -UseDefaultCredentials
        Write-Output -InputObject $Albums
    }
    catch {$PSCmdlet.ThrowTerminatingError($_)}
}