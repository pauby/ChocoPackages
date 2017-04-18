$ErrorActionPreference = 'Stop';

$packageName= 'spiceworks-agent-shell'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.spiceworks.com/ResolveAgent/current/SpiceworksAgentShell.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url

  softwareName  = 'agent shell'

  checksum      = 'DB1FAED669E41523A90FBC5AD16E16E585E51CD98E948FB35D228D63671F2AD6'
  checksumType  = 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

# determine if we need the /sitekey parameter by checking if the package already installed
$upgrade = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs.SoftwareName
Write-Debug "Found $($key.count) registry keys - $key"
if ($key.count -eq 0) {
	# package not installed - we need the /sitekey
	Write-Debug "Package not installed - need /sitekey"

	$arguments = @{}
	$packageParameters = $env:chocolateyPackageParameters

	if ($packageParameters) {
		$match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
		$option_name = 'option'
		$value_name = 'value'

		if ($packageParameters -match $match_pattern ){
			$results = $packageParameters | Select-String $match_pattern -AllMatches
			$results.matches | % {
				$arguments.Add(
					$_.Groups[$option_name].Value.Trim(),
					$_.Groups[$value_name].Value.Trim())
			}
	  	}
	  	else {
			Throw "Package Parameters were found but were invalid (REGEX Failure)"
	  	}

	  	if ($arguments.ContainsKey("sitekey")) {
			Write-Host "SiteKey Argument Found - $($arguments["sitekey"])"
	  	}
	}
	else {
	  Throw "Package Parameter '/sitekey' not passed in."
	}

	$packageArgs.silentArgs = "/qn SITE_KEY=`"$($arguments["sitekey"])`" /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
}
else {
	$upgrade = $true
	Write-Verbose "Package already installed so this is a reinstall or upgrade - /sitekey not needed"
}

Write-Debug "This would be the Chocolatey Silent Arguments: $($packageArgs.silentArgs)"
Install-ChocolateyPackage @packageArgs

Write-Verbose "Starting the Spiceworks Agent Shell Service service"
Start-Service -Name 'AgentShellService' -ErrorAction SilentlyContinue | Out-Null
