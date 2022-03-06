Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://support.techsmith.com/hc/en-us/articles/115006435067-Snagit-Windows-Version-History'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = ": Snagit (?<version>[\d\.]+)"
  $download_page.Content -Match $re

  $version           = $matches.version
  $checksumType64    = 'SHA256'

  # we need to do a couple of things here to get the url version needed to download:
  # if 4 have a patch in the semantic versioning we need to add two zeroes so we can produce fix versions if needed
  # if the version starts with '20' we need to remove that - Snagit advertises the version as '2018' but tags it's installers as '18'
  # remove all the dots from the string version number
  $urlVersion = $version

  # remove the leading '20' if it's there
  if ($urlVersion.StartsWith("20")) {
      $urlVersion = $urlVersion.SubString(2)
  }
  else {
      # something isn't right if it doesn't start with '20' so throw an exception and we can come here to fix it
      throw "Snagit version '$urlVersion' does not start with '20' so they may have changed their version numbering."
  }

  # remove the dots from the version string
  $urlVersion = $urlVersion.Replace('.', '')

  # now we can construct what should be the url
  $Url64 = "https://download.techsmith.com/snagit/releases/$urlVersion/snagit.exe"

  if ([version]$version.major -gt 100) {
    throw "We downloaded a version of Snagit and it's version number is '$version' - anything with a major version > 100 throws this exception. Something is not right and needs fixing."
  }
  else {
    # the version needs to have a '20' added to the start of it.
    if (!($version.StartsWith("20"))) {
    $version = "20" + $version
    }
  }

  # check if we have a revision number and if so append 00 to it for use as a fix version
  # see https://github.com/chocolatey/choco/wiki/CreatePackages#package-fix-version-notation
  if (([version]$version).revision -ne -1) {
    # we have a revision number - add the 00
    $version += "00"
  }

  @{
    Url64             = $Url64
    Version           = $version
    ChecksumType64    = $checksumType64
  }

}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64 -Algorithm $Latest.ChecksumType64
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

Update-Package -ChecksumFor none
