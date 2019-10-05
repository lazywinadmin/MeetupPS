
task -Name nothing {
    "foo"
}

task -Name setEnvironment {
    # Run test build
    # Read the current environment, populate env vars
    Set-BuildEnvironment -Path $rootpath

    # Read back the env vars
    Get-Item ENV:* |
        Sort-Object -property Name
}

task -Name build {
    Write-Verbose -Message "Task: Build"
    # Retrieve public functions
    $publicFiles = @(Get-ChildItem -Path $srcPath\public\*.ps1 -ErrorAction SilentlyContinue)
    # Retrieve private functions
    $privateFiles = @(Get-ChildItem -Path $srcPath\private\*.ps1 -ErrorAction SilentlyContinue)

    # Create build output directory if does not exist yet
    if(-not (Test-Path -path $modulePath))
    {
        New-Item -Path $modulePath -ItemType Directory
    }

    # Build PSM1 file with all the functions
    foreach($file in @($publicFiles + $privateFiles))
    {
        Get-Content -Path $($file.fullname) |
            Out-File -FilePath "$modulePath\$moduleName.psm1" -Append -Encoding utf8
    }

    # Append existing PSM1 content from source
    if(Test-Path -Path "$srcPath\source.psm1")
    {
        Get-Content -path "$srcPath\source.psm1" |
            Out-File -FilePath "$modulePath\$moduleName.psm1" -Append -Encoding utf8
    }

    # Copy the Manifest to the build (psd1)
    Copy-Item -Path "$srcPath\source.psd1" -Destination $modulePath
    Rename-Item -Path "$modulePath\source.psd1" -NewName "$moduleName.psd1" -PassThru -Force

    # Find next module version (BuildHelpers module)
    Write-Verbose -Message "Find next module version (BuildHelpers module)"
    $moduleVersion = Get-NextNugetPackageVersion -Name $moduleName

    $moduleManifestData = @{
        Guid = $Guid
        Author = $author
        Description = $Description
        Copyright = "(c) $((Get-Date).year) $author. All rights reserved."
        Path = "$modulepath\$moduleName.psd1"
        FunctionsToExport = $publicFiles.basename
        Rootmodule = "$moduleName.psm1"
        ModuleVersion = $moduleVersion
        ProjectUri = $projectUri
        CompanyName = $CompanyName
        LicenseUri = $licenseUri
        Tags = $tags
    }
    Update-ModuleManifest @moduleManifestData
    Import-Module -Name $modulePath -RequiredVersion $moduleVersion
}

task -Name clean {
    # Output folder
    Remove-Item -confirm:$false -Recurse -path $buildOutputPath -ErrorAction SilentlyContinue

    # Delete env variables created
    Get-ChildItem -Path env:modulepath,env:modulename,env:bh* -ErrorAction SilentlyContinue | remove-item
}

task -Name deploy {
    $PSDeployFile = Join-Path -Path $buildPath -ChildPath 'build.psdeploy.ps1'
    Invoke-PSDeploy -Path $PSDeployFile -Force
}

task -Name test {
    # Run test build
    $PesterParams = @{
        Script          = @{
            Path = $TestPath;
            Parameters = @{
                moduleName = $moduleName;
                modulePath = $modulePath;
                srcPath = $srcPath;
                }
            }
        OutputFormat    = 'NUnitXml'
        OutputFile      = "$buildOutputPath\$testResult"
        PassThru        = $true
        #Show            = 'Failed', 'Fails', 'Summary'
        #Tags            = 'Build'
    }

    $results = Invoke-Pester @PesterParams

    if($results.FailedCount -gt 0)
    {
        throw "Failed [$($results.FailedCount)] Pester tests."
    }
}


task -name analyze {
    $PSScriptAnalyzerParams = @{
        IncludeDefaultRules = $true
        Path                = "$modulePath" # $ModuleName.psd1"
        Settings            = "$buildPath\ScriptAnalyzerSettings.psd1"
        Severity            = 'Warning','Error'
        Recurse             = $true
    }

    "Analyzing $ManifestPath..."
    $results = Invoke-ScriptAnalyzer @PSScriptAnalyzerParams
    if ($results)
    {
        'One or more PSScriptAnalyzer errors/warnings were found.'
        'Please investigate or add the required SuppressMessage attribute.'
        $results | Format-Table -AutoSize
    }
}