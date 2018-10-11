$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests','.\MeetupPS\public'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-MeetupEvent unit testing" {
	Context -Name "Error Conditions" -Fixture {
		It "Bad Parameters" {
			{ New-MeetupEvent -GroupName "Does not Exist" -Title "Bad Title"} | Should -Throw
        }#It
    }#Context Error conditions
}#Describe