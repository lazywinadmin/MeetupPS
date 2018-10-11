$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests','.\MeetupPS\public'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Set-MeetupConfiguration unit testing" {
	Context -Name "Error Conditions" -Fixture {
		It "Bad Parameters" {
			{ Set-MeetupConfiguration } | Should -Throw
        }#It
    }#Context Error conditions
}#Describe