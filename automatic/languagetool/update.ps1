. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://api.github.com/repos/languagetool-org/languagetool/tags'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$extractedFolderName\s*=\s*)(''.*'')'    = "`$1'languagetool-$($Latest.Version)'"
            '(^\s*\$zipFile\s*=\s*)(''.*'')'                = "`$1'languagetool-$($Latest.Version).zip'"
            # "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            # "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }

        ".\tools\VERIFICATION.txt"      = @{
            "(^\s*x86 URL:\s*)(.*)"          = "`$1$($Latest.URL32)"
            "(^\s*x86 Checksum Type:\s*)(.*)" = "`$1$($Latest.ChecksumType32)"
            "(^\s*x86 Checksum:\s*)(.*)"      = "`${1}$($Latest.Checksum32)"
        }
    }
}

function global:au_BeforeUpdate() {

    Write-Host "Downloading 'installer' file $localFile"

    $localFile = ("tools\languagetool-{0}.zip" -f $Latest.version)
    Get-Item -Path 'tools\*.zip' -Force -ErrorAction SilentlyContinue | Out-Null

    $localProgressPref = $ProgressPreference
    $ProgressPreference = 'SilentyCntinue'
    Invoke-WebRequest -UseBasicParsing -Uri $Latest.URL32 -OutFile $localFile
    $ProgressPreference = $localProgressPref

    $Latest.ChecksumType32 = 'SHA256'
    $Latest.Checksum32 = (Get-FileHash $localFile -Algorithm $Latest.ChecksumType32).Hash
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
        URL32   = $url
        Version = $version
    }
}

Update-Package -ChecksumFor none