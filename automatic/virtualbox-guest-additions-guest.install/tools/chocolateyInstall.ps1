$ErrorActionPreference = 'Stop'

$file           = "VBoxGuestAdditions_$packageVersion.iso"
$binX86Filename = 'VBoxWindowsAdditions-x86.exe'
$binX64Filename = 'VBoxWindowsAdditions-amd64.exe'

$url            = "https://download.virtualbox.org/virtualbox/$packageVersion/$file"
$checksum       = 'c987cdc8c08c579f56d921c85269aeeac3faf636babd01d9461ce579c9362cdd'
$checksumType   = 'sha256'
$unzipLocation  = "$ENV:TMP\$file"


# Download + extract the ISO
	$zipArgs = @{
		packageName   = $ENV:ChocolateyPackageName
		url           = $url
		unzipLocation = $unzipLocation
		checksum      = $checksum
		checksumType  = $checksumType
	}

	Install-ChocolateyZipPackage @zipArgs


# Download + install the Oracle certificate
	$certFileName = 'Trusted-OracleCorporationVirtualBox-05308b76ac2e15b29720fb4395f65f38.cer'
	$certUrl      = "https://www.virtualbox.org/svn/vbox/trunk/src/VBox/HostDrivers/Support/Certificates/$certFileName"
	$certFile     = Join-Path $unzipLocation $certFileName
	$WebClient    = [System.Net.WebClient]::new()
	$WebClient.DownloadFile($certUrl, $certFile)

	$certFile       = Join-Path $unzipLocation "Trusted-OracleCorporationVirtualBox-05308b76ac2e15b29720fb4395f65f38.cer"
	certutil -addstore -f "TrustedPublisher" $certFile


# Install the EXE
	$packageArgs = @{
		packageName    = $ENV:ChocolateyPackageName
		fileType       = 'EXE'
		file           = Join-Path $unzipLocation $binX86Filename
		file64         = Join-Path $unzipLocation $binX64Filename
		silentArgs     = '/S'
		validExitCodes = @(0)
	}

	Install-ChocolateyInstallPackage @packageArgs