Function Get-OauthCode {
    <#
.SYNOPSIS
    Function to show the Microsoft Authentication window
.NOTES
    https://github.com/lazywinadmin/MVP
    
    #Credit to Stephen Owen: https://raw.githubusercontent.com/1RedOne/PSWordPress/master/Private/Show-oAuthWindow.ps1
#>
    [CmdletBinding()]
    Param(
        [Uri]$url, $Width = 440, $Height = 640
    )
    Process {

        $Scriptname = (Get-Variable -name MyInvocation -Scope 0 -ValueOnly).MyCommand

        try {
            Write-Verbose -Message "[$ScriptName] Load assembly System.Windows.Forms"
            Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop

            Write-Verbose -Message "[$ScriptName] Create Form"
            $global:form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width = $Width; Height = $Height}
            
            Write-Verbose -Message "[$ScriptName] Create Web browser"
            $global:web = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Width = 420; Height = 600; Url = $url}
            # define $uri in the immediate parent scope: 1
            Write-Verbose -Message "[$ScriptName] Define DocumentCompleted scriptblock"
            $global:DocComp = {
                $global:uri = $web.Url.AbsoluteUri
                if ($global:uri -match 'error=[^&]*|code=[^&]*') {
                    $global:form.Close()
                }
            }
            $global:web.ScriptErrorsSuppressed = $true
            $global:web.Add_DocumentCompleted($DocComp)
            $global:form.Controls.Add($web)
            $global:form.Add_Shown( {$form.Activate()})

            Write-Verbose -Message "[$ScriptName] Show Dialog"
            $null = $form.ShowDialog()

            
            $uri
            
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}

