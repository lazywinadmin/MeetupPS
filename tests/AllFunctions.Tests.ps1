$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', '.\MeetupPS'

Describe -Name "Basic code review across all functions" -Fixture {
	Context -Name "Public functions" -Fixture {
		Get-ChildItem -Path "$here\Public" | ForEach-Object {
			$FunctionDeclaration = Get-Content -Path $PSItem | Select-String "^Function"
			It -Name ($PSItem.BaseName + " has verb-noun declaration") {
				$FunctionDeclaration | Should -Match '([\w]+\s)([\w]+)([\-\w]*\s{)'
			}
			It -Name ($PSItem.BaseName + " contains function approved verb") -test {
				
				$Verb = $FunctionDeclaration -replace '([\w]+\s)([\w]+)([\-\w]*\s{)', '$2'
				$Verbs = Get-Verb | Select-Object -ExpandProperty Verb
				$Verbs | Should -Contain $Verb
			}#It Verb-Noun
		}#Foreach File
		It -Name "Script Analyzer Checks" -test {
			Invoke-ScriptAnalyzer -Path "$here\Private" -Recurse -Severity Error | SHould -BeNullOrEmpty
		}
	}#Context Private Functions
	Context -Name "Private functions" -Fixture {
		It -Name "Script Analyzer Checks" -test {
			Invoke-ScriptAnalyzer -Path "$here\Private" -Recurse -Severity Error | SHould -BeNullOrEmpty
		}
	}
}#Describe