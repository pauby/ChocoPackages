#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://github.com/imbushuo/mac-precision-touchpad/releases'

function global:au_SearchReplace {
}

function global:au_BeforeUpdate {
    do {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid().ToString())
    }
    while (Test-Path -Path $tempPath)

    $filename = "$tempPath.zip"
    Invoke-WebRequest -Uri $Latest.URL64 -UseBasicParsing -OutFile $filename
    Expand-Archive -Path $filename -Destination "tools" -Force
}

# This was failing which may have been failing the build.
# function global:au_AfterUpdate {
#     Set-DescriptionFromReadme -SkipFirst 2
# }

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = 'releases/download/(?<version>[\d-]+)/Driver(s)?-amd64-ReleaseMSSigned\.zip'
    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href
    $dotVersion = $matches.version.Replace('-', '.')

    return @{
        URL64   = "https://github.com/$url"
        Version = "0.$dotVersion"
    }
}

update -ChecksumFor none