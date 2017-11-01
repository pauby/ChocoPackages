$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'pdffactorypro-workstation'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://fineprint.com/release/pdf620pro.exe'

$packageArgs = @{
    packageName   = $packageName
    unzipLocation = $toolsDir
    fileType      = 'EXE'
    url           = $url

    softwareName  = 'pdfFactory Pro'

    checksum      = 'b38b1d0d05fe341bb165df8d9328adbecf1594965fff990cd70df18a8dfe42e4'
    checksumType  = 'SHA256'

    silentArgs = '/quiet /reboot=0'
    validExitCodes= @(0)
}

. "$toolsDir\PaubyChocoExtensions.ps1"
write-debug "OS Name: $($env:OS_NAME)"
if (Test-ChocoServerOS) {
    throw "Cannot be installed on a Server operating system ($($env:OS_NAME)."
}

$tempDir = Get-ChocoUniqueTempName
New-Item -ItemType Directory -Path $tempDir

$file = Join-Path $tempDir "$($packageName)Install.exe"
Get-ChocolateyWebFile -PackageName $packageArgs.packageName -FileFullPath $file -Url $packageArgs.url -Checksum $packageArgs.checksum -ChecksumType $packageArgs.checksumType
Get-ChocolateyUnzip -FileFullPath $file -Destination $tempDir

$arguments = ConvertFrom-ChocoParameters -Parameter $env:chocolateyPackageParameters
$setup = Join-Path -Path $tempDir -ChildPath "setup.exe"
$paramLang = $paramName = $paramLicenseCode = $paramMargins = "<NOT SPECIFIED>"
$languageMap = @{ "zh-CN" = "0804"; "zh-TW" = "0404"; "cs" = "0405"; "da" = "0406"; "nl" = "0413"; "en" = "0409"; "fr" = "040c"; "de" = "0407"; "it" = "0410"; "ja" = "0411"; "pl" = "0415"; "pt" = "0416"; "ru" = "0419"; "sk" = "041b"; "es" = "0c0a"; "sv" = "041d"; }

$iniFile = Join-Path -Path $tempDir -ChildPath "fpp6.ini"

if($arguments.ContainsKey("lang")) {
    $paramLang = $arguments["lang"]
    if(!$languageMap.ContainsKey($paramLang)) {
        throw "Unknown language '$paramLang' specified. The following languages are available:`n" + $languageMap.Keys -join "`n"
    }
    $silentArgs += " /lang=" + $languageMap[$paramLang]
}

if($arguments.ContainsKey("license")) {
    $paramLicenseCode = $arguments["license"]
    $name = ""

    if($arguments.ContainsKey("name")) {
        $paramName = $arguments["name"]
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
Install-ChocolateyInstallPackage @packageArgs -File $setup

Remove-Item -Path $tempDir -Recurse
