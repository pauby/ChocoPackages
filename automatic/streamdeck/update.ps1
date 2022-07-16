Import-Module AU
. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://gc-updates.elgato.com/windows/sd-update/final/app-version-check.json'

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
}

function global:au_AfterUpdate {
  Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

  $update = Invoke-RestMethod -Uri $releases

  return @{
    Url64   = $update.manual.fileURL
    Version = $update.manual.version
  }
}

Update-Package -ChecksumFor 64
