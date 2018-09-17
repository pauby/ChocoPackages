$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = $toolsDir
    fileType      = 'EXE'
    url           = 'https://fineprint.com/release/pdf632pro.exe'
    checksum      = '81ff95ec3fdf23aecb6b838245884c9aaffafaf7993405ce023a0837579cfab9'
    checksumType  = 'SHA256'
    silentArgs = '/quiet /reboot=0'
    validExitCodes= @(0)
}

Write-debug "OS Name: $($env:OS_NAME)"
if ($env:OS_NAME -like "*Server*") {
    throw "Cannot be installed on a Server operating system ($($env:OS_NAME))."
}

# create temp directory
do {
    $tempDir = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
} while (Test-Path $tempDir)
New-Item -ItemType Directory -Path $tempDir | Out-Null

# Get installer and unzip it
$packageArgs.file = Join-Path $tempDir "$($packageName)Install.exe"
Get-ChocolateyWebFile @packageArgs
Get-ChocolateyUnzip -FileFullPath $packageArgs.file -Destination $tempDir

# recurse through the args
$arguments = Get-PackageParameters -Parameter $env:ChocolateyPackageParameters
$packageArgs.file = Join-Path -Path $tempDir -ChildPath 'setup.exe'
$paramLang = $paramName = $paramLicenseCode = $paramMargins = "<NOT SPECIFIED>"
$languageMap = @{ 
    "zh-CN" = "0804"
    "zh-TW" = "0404"
    "cs"    = "0405"
    "da"    = "0406"
    "nl"    = "0413"
    "en"    = "0409"
    "fr"    = "040c"
    "de"    = "0407"
    "it"    = "0410"
    "ja"    = "0411"
    "pl"    = "0415"
    "pt"    = "0416"
    "ru"    = "0419"
    "sk"    = "041b"
    "es"    = "0c0a"
    "sv"    = "041d"
}
$iniFile = Join-Path -Path $tempDir -ChildPath "fpp6.ini"

if($arguments.ContainsKey("lang")) {
    $paramLang = $arguments["lang"]
    if(!$languageMap.ContainsKey($paramLang)) {
        throw "Unknown language '$paramLang' specified. The following languages are available:`n" + $languageMap.Keys -join "`n"
    }
    $packageArgs.silentArgs += " /lang=" + $languageMap[$paramLang]
}

if($arguments.ContainsKey("license")) {
    $paramLicenseCode = $arguments["license"]
    
    if($arguments.ContainsKey("name")) {
        $paramName = $arguments["name"]
    }
    else {
        $paramName = ''
    }

@"
[Settings]
Name=$paramName
SerialNumber=$paramLicenseCode
"@ | Out-File $iniFile
}

if($arguments.ContainsKey("margins")) {
    if ($arguments["margins"] -match "\d \d \d \d") {
        $result = $arguments["margins"] | Select-String "\d \d \d \d"
        $paramMargins = $result.matches.value -split(" ") | ForEach-Object { [int]$_ }

        "[Registry]" | Out-File -Filepath $iniFile -Append
        "HKCU\Software\FinePrint Software\pdfFactory5\FinePrinters\pdfFactory Pro\PrinterDriverData\MarginLeft=$($paramMargins[3])" | Out-File -Filepath $iniFile -Append
        "HKCU\Software\FinePrint Software\pdfFactory5\FinePrinters\pdfFactory Pro\PrinterDriverData\MarginTop=$($paramMargins[0])" | Out-File -Filepath $iniFile -Append
        "HKCU\Software\FinePrint Software\pdfFactory5\FinePrinters\pdfFactory Pro\PrinterDriverData\MarginRight=$($paramMargins[1])" | Out-File -Filepath $iniFile -Append
        "HKCU\Software\FinePrint Software\pdfFactory5\FinePrinters\pdfFactory Pro\PrinterDriverData\MarginBottom=$($paramMargins[2])" | Out-File -Filepath $iniFile -Append
   }
   else {
       throw "Incorrect number of margin values specified. Please specify four numbers, separated by spaces, e.g. /margins:`"0 0 0 0`". You specified: '$marginsParameter'"
   }
}

Write-Debug "Parameters:`n`tLanguage: $paramLang`n`tLicense:  $paramLicenseCode`n`tName:`t  $paramName`n`tMargins:  $paramMargins"
Install-ChocolateyInstallPackage @packageArgs

Remove-Item -Path $tempDir -Recurse -ErrorAction SilentlyContinue
