$ErrorActionPreference = 'Stop'

function ConvertFrom-ChocoParameters ([string]$parameter) {
    $arguments = @{};

    if ($parameter) {
        $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
        $option_name = 'option'
        $value_name = 'value'

        if ($parameter -match $match_pattern) {
            $results = $parameter | Select-String $match_pattern -AllMatches
            $results.matches | ForEach-Object {
                $arguments.Add(
                    $_.Groups[$option_name].Value.Trim(),
                    $_.Groups[$value_name].Value.Trim())
            }
        }
        else {
            throw "Package Parameters were found but were invalid (REGEX Failure). See package description for correct format."
        }
    }

    return $arguments
}

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageName  = 'outlookcaldav'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//aluxnimm/outlookcaldavsynchronizer/releases/download/v3.1.0/OutlookCalDavSynchronizer-3.1.0.zip'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  file          = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\CalDavSynchronizer.Setup.msi"

  softwareName  = 'OutlookCalDavSynchronizer*'

  checksum      = 'f4144f93a5157ef894b8f7a2ceb4a8cbfa5e6ab23c4ac93b5b8678c5487e09e1'
  checksumType  = 'SHA256'

  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}

$arguments = ConvertFrom-ChocoParameters -Parameter $env:chocolateyPackageParameters
if ($arguments.ContainsKey("allusers")) {
    $packageArgs.silentArgs += " ALLUSERS=1"
}

Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs
