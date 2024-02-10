# chocolatey-os-dependency.extension v0.0.1 (04-28-2022) by Bill Curran AKA BCURRAN3 - public domain

# Confirms OS is Windows 11 and aborts if not. If no build number is specified, it defaults to the initial release build.
# Can be sent a particular build # to check as minimum.
# REF: https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions
function Confirm-Win11{
  Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [int]
    $ReqBuild
  )
  
$OSMajor=[Environment]::OSVersion.Version.Major
$OSBuild=[Environment]::OSVersion.Version.Build
if (!$ReqBuild) {$ReqBuild = 22000}
Write-Host OS Dependency Check: OSMajor = $OSMajor OSBuild = $OSBuild Minimum Required Build = $ReqBuild -Foreground Magenta
if ($OSMajor -eq 10 -and $OSBuild -ge 22000 -and $OSBuild -ge $ReqBuild) {
	return
	 } else {
		 Write-Host "WARNING:   ** Windows 11 Build $ReqBuild or higher required." -Foreground Red
		 throw
		 }
}

# Confirms OS is Windows 10 (or 11) and aborts if not. If no build number is specified, it defaults to the initial release build.
# Can be sent a particular build # to check as minimum.
# REF: https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions
function Confirm-Win10{
  Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [int]
    $ReqBuild
  )

$OSMajor=[Environment]::OSVersion.Version.Major
$OSBuild=[Environment]::OSVersion.Version.Build
if (!$ReqBuild) {$ReqBuild = 10240}
Write-Host OS Dependency Check: OSMajor = $OSMajor OSBuild = $OSBuild Minimum Required Build = $ReqBuild -Foreground Magenta
if ($OSMajor -eq 10 -and $OSBuild -ge 10240 -and $OSBuild -ge $ReqBuild) {
	return
	 } else {
		 Write-Host "WARNING:   ** Windows 10 Build $ReqBuild or higher required." -Foreground Red
		 throw
		 }
}

# Confirms OS is Windows 8.1 and aborts if not.
function Confirm-Win81{
  Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [int]
    $ReqBuild
  )
  
$OSMajor=[Environment]::OSVersion.Version.Major
$OSMinor=[Environment]::OSVersion.Version.Minor
$OSBuild=[Environment]::OSVersion.Version.Build
if (!$ReqBuild) {$ReqBuild = 9600}
Write-Host OS Dependency Check: OSMajor = $OSMajor OSBuild = $OSBuild Minimum Required Build = $ReqBuild -Foreground Magenta
if ($OSMajor -eq 6 -and $minor -eq 3 -and $OSBuild -ge 9600 -and $OSBuild -ge $ReqBuild) {
	return
	 } else {
		 Write-Host "WARNING:   ** Windows 8.1 Build $ReqBuild or higher required." -Foreground Red 
		 throw
		 }
}

# Confirms OS is Windows 8.0 and aborts if not.
function Confirm-Win80{
  Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [int]
    $ReqBuild
  )
  
$OSMajor=[Environment]::OSVersion.Version.Major
$OSMinor=[Environment]::OSVersion.Version.Minor
$OSBuild=[Environment]::OSVersion.Version.Build
if (!$ReqBuild) {$ReqBuild = 9200}
Write-Host OS Dependency Check: OSMajor = $OSMajor OSBuild = $OSBuild Minimum Required Build = $ReqBuild -Foreground Magenta
if ($OSMajor -eq 6 -and $minor -eq 2 -and $OSBuild -ge 9200 -and $OSBuild -ge $ReqBuild) {
	return
	 } else {
		 Write-Host "WARNING:   ** Windows 8.0 Build $ReqBuild or higher required." -Foreground Red 
		 throw
		 }
}

# Confirms OS is Windows 8.0 or 8.1 and aborts if not.
function Confirm-Win8{
  Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [int]
    $ReqBuild
  )
  
$OSMajor=[Environment]::OSVersion.Version.Major
$OSBuild=[Environment]::OSVersion.Version.Build
if (!$ReqBuild) {$ReqBuild = 9200}
Write-Host OS Dependency Check: OSMajor = $OSMajor OSBuild = $OSBuild Minimum Required Build = $ReqBuild -Foreground Magenta
if ($OSMajor -eq 6 -and $OSBuild -ge 9200 -and $OSBuild -ge $ReqBuild) {
	return
	 } else {
		 Write-Host "WARNING:   ** Windows 8 Build $ReqBuild or higher required." -Foreground Red 
		 throw
		 }
}

# Confirms OS is Windows 7 and aborts if not.
function Confirm-Win7{
  Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [int]
    $ReqBuild
  )
  
$OSMajor=[Environment]::OSVersion.Version.Major
$OSMinor=[Environment]::OSVersion.Version.Minor
$OSBuild=[Environment]::OSVersion.Version.Build
if (!$ReqBuild) {$ReqBuild = 7601}
Write-Host OS Dependency Check: OSMajor = $OSMajor OSBuild = $OSBuild Minimum Required Build = $ReqBuild -Foreground Magenta
if ($OSMajor -eq 6 -and $minor -lt 1 -and $OSBuild -ge 7601 -and $OSBuild -ge $ReqBuild) {
	return
	 } else {
		 Write-Host "WARNING:   ** Windows 7 Build $ReqBuild or higher required." -Foreground Red 
		 throw
		 }
}

# Confirms Windows has a minimum build number and aborts if not. Not major version specific.
function Confirm-WinMinimumBuild{
  Param(
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true)]
    [int]
    $ReqBuild
  )
  
$OSMajor=[Environment]::OSVersion.Version.Major
$OSBuild=[Environment]::OSVersion.Version.Build
Write-Host OS Dependency Check: OSMajor = $OSMajor OSBuild = $OSBuild Minimum Required Build = $ReqBuild -Foreground Magenta
if ($OSBuild -ge $ReqBuild) {
	return
	 } else {
		 Write-Host "WARNING:   ** Windows Build $ReqBuild or higher required." -Foreground Red
		 throw
		 }
}

# Confirms Windows is build x and aborts if not. Not major version specific.
function Confirm-WinRequiredBuild{
  Param(
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true)]
    [int]
    $ReqBuild
  )
  
$OSMajor=[Environment]::OSVersion.Version.Major
$OSBuild=[Environment]::OSVersion.Version.Build
Write-Host OS Dependency Check: OSMajor = $OSMajor OSBuild = $OSBuild MRequired Build = $ReqBuild -Foreground Magenta
if ($OSBuild -eq $ReqBuild) {
	return
	 } else {
		 Write-Host "WARNING:   ** Windows Build $ReqBuild required." -Foreground Red
		 throw
		 }
}
