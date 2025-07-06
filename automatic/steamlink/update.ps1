. $PSScriptRoot\..\..\scripts\all.ps1

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'              = "`$1'$($Latest.Url32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}


function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $url32 = 'https://media.steampowered.com/steamlink/windows/latest/SteamLink.zip'

    $tempFolder = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).ToString()
    $zipPath = Join-Path -Path $tempFolder -ChildPath 'SteamLink.zip'
    $msiPath = Join-Path -Path $tempFolder -ChildPath 'SteamLink.msi'

    New-Item -Path $tempFolder -Force -ItemType Directory
    Invoke-WebRequest -Uri $url32 -OutFile $zipPath

    Expand-Archive -Path $zipPath -DestinationPath $tempFolder
    #& 7z.exe e -aoa $zipPath "SteamLink.msi" -o"$tempFolder"

    $version = Get-MsiProductVersion -Path $msiPath

    if ($version -notmatch "[\d]*\.[\d]*\.[\d]*(\.[\d])?") {
        throw "Version number '$version' isn't a valid version as it doesn't match the regex"
    }

    return @{
        Url32          = $url32
        Version        = $version
        Checksum32     = (Get-FileHash -Path $zipPath -Algorithm 'SHA256').Hash
        ChecksumType32 = 'SHA256'
    }
}

Update-Package -ChecksumFor none
