#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$moduleName  = 'dbatools.library'

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            # We use ChocolateyPackageVersion to minimise changes to the package code -
            # If using a patchfix version, use the moduleversion instead of the packageversion.
            '(\s*\$moduleVersion\s*=\s*)(\$env:ChocolateyPackageVersion|(["'']?).+["'']?)' = "`${1}$(
                if ($Latest.ModuleVersion -ne $Latest.Version) {
                    $Quote = if ($Matches.'3') {'${3}'} else {"'"}
                    $Quote + $Latest.ModuleVersion + $Quote
                } else {
                    '$env:ChocolateyPackageVersion'
                }
            )"
        }
    }
}

function global:au_BeforeUpdate() {
    do {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).ToString()
    }
    while (Test-Path $tempPath)

    New-Item -Path $tempPath -ItemType Directory | Out-Null
    Save-Module -Name $moduleName -RequiredVersion $Latest.ModuleVersion -Path $tempPath
    $modulePath = Join-Path -Path $tempPath -ChildPath "\$ModuleName\$($Latest.ModuleVersion)\"

    $zipPath = Join-Path -Path $tempPath -ChildPath "$moduleName.zip"
    Compress-Archive -Path (Join-Path -Path $modulePath -ChildPath "*") -DestinationPath $zipPath -CompressionLevel Optimal

    $params = @{
        Path        = $zipPath
        Destination = "tools\"
        Force       = $true
    }
    Move-Item @params
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $version = (Find-Module -Name $moduleName).Version.ToString()

    return @{
        Version       = $version
        ModuleVersion = $version
    }
}

update -ChecksumFor none