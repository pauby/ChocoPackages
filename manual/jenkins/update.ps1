#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://www.jenkins.io/download/'
$downloadURL = 'http://mirrors.jenkins-ci.org/windows-stable/'

function global:au_SearchReplace {
    @{
#        'tools\chocolateyInstall.ps1' = @{
#            "(?i)(^\s*url\s*=\s*)('.*')"             = "`$1'$($Latest.URL)'"
#            "(?i)(^\s*checksum\s*=\s*)('.*')"        = "`$1'$($Latest.Checksum32)'"
#            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
#        }
    }
}

function global:au_BeforeUpdate {
    $filename = "tools\jenkins.msi"

    if (Test-Path -Path $filename) {
        Remove-Item -Path $filename -Force
    }

    Invoke-WebRequest -Uri $Latest.URL -UseBasicParsing -OutFile $filename
}

function global:au_GetLatest {
    # needed for Invoke-WebRequest to work for this site
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = "Download Jenkins`n(?<version>[\d\.]+)`nLTS"
    $page.RawContent -match $regexUrl
    $version = $matches.version

    return @{
        URL   = "$downloadURL/$version/jenkins.msi"
        Version = $version
    }
}

update -ChecksumFor none
