#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://ftp.gnu.org/gnu/emacs/windows' # no trailing slash

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(?i)(^\s*\$softwareVersion\s*=\s*)(''.*'')' = "`$1'$($Latest.Version)'"
        }
        ".\tools\VERIFICATION.txt" = @{
            "(^\s*x64 URL:\s*)(.*)"           = "`$1$($Latest.URL64)"
            "(^\s*x64 Checksum Type:\s*)(.*)" = "`$1$($Latest.ChecksumType64)"
            "(^\s*x64 Checksum:\s*)(.*)"      = "`${1}$($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.ChecksumType64 = 'SHA256'
    Get-RemoteFiles -Purge
    $Latest.Checksum64 = (Get-FileHash -Path "tools\emacs-$($Latest.Version)_x64.zip" -Algorithm $Latest.ChecksumType64).Hash
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # get all major versions that are available (28, 29, 30 etc.), choose the latest and open that page
    $majorVer = @()
    ForEach ($p in $page.links.href) {
        if ($p -match 'emacs-(?<version>[\d]+)') {
            $majorVer += $matches.version
        }
    }

    # we assume at this stage that they are sorted in the correct order so we just grab the last one
    $majorVer = $majorVer | Select-Object -Unique -Last 1

    # get all of the files within the page
    $downloadPage = Invoke-WebRequest "$releases/emacs-$majorVer" -UseBasicParsing

    $versions = @()
    ForEach ($v in $downloadPage.links.href) {
        if ($v -match 'emacs-(?<version>[\d\.]+)-') {
            $versions += $matches.version
        }
    }
    # we assume at this stage that they are sorted in the correct order so we just grab the last one 
    $version = $versions | Select-Object -Unique -Last 1

    return @{
        URL64   = "$releases/emacs-$majorVer/emacs-$version.zip"
        Version = $version
    }
}

Update-Package -ChecksumFor none
