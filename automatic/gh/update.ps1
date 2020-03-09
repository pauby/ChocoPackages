#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://github.com/cli/cli/releases' # no trailing slash!

function global:au_SearchReplace {
}

function global:au_BeforeUpdate {
    do {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).ToString()
    }
    while (Test-Path $tempPath)

    New-Item -Path $tempPath -ItemType Directory | Out-Null
    $filename = "gh_{0}_windows_amd64.msi" -f $Latest.Version
    Invoke-WebRequest -Uri $Latest.URL64 -UseBasicParsing -OutFile (Join-Path -Path 'tools' -ChildPath $filename)
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = '/download/v(?<version>[\d\.]+)/gh_[\d\.]+_windows_amd64.msi'
    $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href

    return @{
        URL64 = ("{0}{1}" -f $releases, $matches[0])
        Version = $matches.version
    }
}

update -ChecksumFor None