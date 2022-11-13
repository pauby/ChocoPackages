. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://gc-updates.elgato.com/windows/wl-update/final/app-version-check.json'

function global:au_SearchReplace {
  @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url64\s*=\s*)(''.*'')'              = "`$1'$($Latest.Url64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}


function global:au_BeforeUpdate() {
  $Latest.ChecksumType64 = 'SHA256'
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64 -Algorithm $Latest.ChecksumType64
}

function global:au_AfterUpdate {
  Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

  $update = Invoke-RestMethod -Uri $releases

  return @{
    Url64   = $update.automatic.fileURL
    Version = $update.automatic.version
  }
}

Update-Package -ChecksumFor none