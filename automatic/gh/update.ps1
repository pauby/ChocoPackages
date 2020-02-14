#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

# no trailing slash!
$releases    = 'https://github.com/cli/cli/releases'

function global:au_SearchReplace {
}

function global:au_BeforeUpdate {
    do {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).ToString()
    }
    while (Test-Path $tempPath)

    New-Item -Path $tempPath -ItemType Directory | Out-Null
    $filename = "gh_{0}_windows_amd64.msi" -f $Latest.Version
    $uri = "{0}/download/v{1}/{2}" -f $releases, $Latest.Version, $filename
    Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile (Join-Path -Path 'tools' -ChildPath $filename)
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = '/download/v(?<version>[\d\.]+)/gh_'
    $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href
    $version = $matches.version

    return @{
        Version      = $version
    }
}

update -ChecksumFor None