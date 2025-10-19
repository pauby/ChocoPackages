. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://www.privateinternetaccess.com/download/windows-vpn#download-windows'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $tempFolder = Join-Path -Path $env:TEMP -ChildPath ([Guid]::NewGuid()).Guid
    New-Item -Path $tempFolder -ItemType Directory -Force

    $savedProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    Invoke-WebRequest -Uri $Latest.Url64 -OutFile (Join-Path -Path $tempFolder -ChildPath '64bit.exe') -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::FireFox)
    $Latest.Checksum64 = (Get-FileHash -Path (Join-Path -Path $tempFolder -ChildPath '64bit.exe')).Hash

    $ProgressPreference = $savedProgressPreference
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $version = $download_page.links.href -match 'pia-windows' | Select-Object -First 1 | ForEach-Object { $_ -split '-' | Select-Object -Last 2 }
    $secondVersion = $version[1].Substring(0, $version[1].length - 4)
    $version = $version[0]
    $chocoPackageVersion = '290.' + $version

    @{
        Version = $chocoPackageVersion
        URL64   = "https://installers.privateinternetaccess.com/download/pia-windows-x64-$version-$secondVersion.exe"
    }
}

Update-Package -ChecksumFor 'none'

