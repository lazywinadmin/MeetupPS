$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests','.\MeetupPS\public'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-MeetupEvent unit testing" {
	Context -Name "Error Conditions" -Fixture {
		It "Bad Parameters" {
			{ Get-MeetupEvent -GroupName "Does not Exist"} | Should -Throw
        }#It
    }#Context Error conditions
}#Describe