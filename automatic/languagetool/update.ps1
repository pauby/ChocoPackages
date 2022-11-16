. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://api.github.com/repos/languagetool-org/languagetool/tags'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$extractedFolderName\s*=\s*)(''.*'')'    = "`$1'languagetool-$($Latest.Version)'"
            '(^\s*\$zipFile\s*=\s*)(''.*'')'                = "`$1'languagetool-$($Latest.Version).zip'"
            '(^\s*url\s*=\s*)(''.*'')'                      = "`$1'$($Latest.Url32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"               = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"           = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {

    # we can't embed this package as it's too large!
    $Latest.ChecksumType32 = 'SHA256'

    $localProgressPref = $ProgressPreference
    $ProgressPreference = 'SilentyContinue'
    $Latest.Checksum32 = Get-RemoteChecksum -Algorithm $Latest.ChecksumType32 -Url $Latest.Url32
    $ProgressPreference = $localProgressPref
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $latestTag = (Invoke-RestMethod -Uri $releases -UseBasicParsing) | Select-Object -First 1 -Property name
    if (-not ($latestTag -match '[\d\.]+')) {
        return
    }
    $version = $matches[0]

    $url = ("https://languagetool.org/download/LanguageTool-{0}.zip" -f $version)   # case of the filename matters here
    return @{
        Url32   = $url
        Version = $version
    }
}

Update-Package -ChecksumFor none