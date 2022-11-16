$ErrorActionPreference = 'Stop'

$installToolsPath = Get-ToolsLocation
$installPath = Join-Path -Path $installToolsPath -ChildPath 'languagetool\'
$backupFolderName = 'languagetool-backup.CREATED-BY-PACKAGE'
$backupPath = Join-Path -Path $installToolsPath -ChildPath $backupFolderName
$extractedFolderName = 'languagetool-5.9'
$zipFile = 'languagetool-5.9.zip'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://languagetool.org/download/LanguageTool-5.9.zip'
    checksum       = '0d06c2e8b016c105d24a242aa4967329a4cc8f7ffc95fb0e11113bd9db48c4ac'
    checksumType   = 'SHA256'
    unzipLocation  = $installToolsPath
    specificFolder = $extractedFolderName
}

# warn if no java detected but don't stop the install as it's not needed for installation only for running the server
if (-not (Get-Command -Name 'java.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "LanguageTool requires a flavour of jre8 to be installed in order to run the server. As there are so many flavours, this package does not recommend a specific one. Please install a flavour of jre8 before trying to run 'languagetool'."
}

# each version will put the LanguageTool binaries into a folder named 'LanguageTool-<VERSION>'
# for consistency, lets move it to the 'LanguageTool' folder in the tools location
if (-not (Test-Path -Path $installToolsPath)) {
    New-Item -Path $installToolsPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
}

# if the backup folder exists, remove it
if (Test-Path -Path $backupPath) {
    Write-Warning "The package backup folder $backupPath exists. Will remove it."
    Remove-Item -Path $backupPath -Force -Recurse
}

    # rename the current install folder if it exists
if (Test-Path -Path $installPath) {
    Write-Warning "Creating a backup of the install folder at $backupPath"
    Rename-Item -Path $installPath -NewName $backupFolderName -Force
}

Install-ChocolateyZipPackage @packageArgs

# rename the extracted folder to make it the installed package path
Rename-Item -Path (Join-Path -Path $installToolsPath -ChildPath $extractedFolderName) -NewName 'languagetool' -Force | Out-Null

# remove the languagetool.backup folder
if (Test-Path -Path $backupPath) {
    try {
        Remove-Item -Path $backupPath -Force -Recurse | Out-Null
    }
    catch {
        Write-Warning ("Could not remove the backup folder {0}. Please remove this manually." -f $backupPath)
    }
}

Write-Host "LanguageTool installed to $installPath"

# remove the package Zip file
Remove-Item -Path (Join-Path -Path $installToolsPath -ChildPath $zipFile) -Force -ErrorAction SilentlyContinue | Out-Null
