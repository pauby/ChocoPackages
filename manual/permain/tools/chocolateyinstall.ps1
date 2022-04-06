$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName

  fileType      = 'exe'
  url           = 'https://downloads.sourceforge.net/project/pcsm/0.7/pcsm-setup-0.7.exe'

  # If exit code - 1223, program will be still installed successfully.
  validExitCodes = (0, 1223)

  checksum      = '41D115BCFB3194C7C33D17D76DA9CB7039C0C052B73EE5D7F27C2800AA995326'
  checksumType  = 'sha256'

  silentArgs   = '/S'
}

Install-ChocolateyPackage @packageArgs
