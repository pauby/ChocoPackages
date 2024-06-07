$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$versPath = 'vim91'
#$filename32 = "$toolsDir\complete-x86.7z"
$filename64 = "$toolsDir\complete-x64.7z"

# package parameter defaults
$destDir = Join-Path -Path $env:ProgramFiles -ChildPath "Vim\$versPath"
$createBatFiles = '-create-batfiles vim gvim evim view gview vimdiff gvimdiff'
$installPopUp = $null

$pp = Get-PackageParameters

if ($pp['InstallDir']) {
    $destDir = $pp['InstallDir']
    $destDir = $destDir -replace '^[''"]|[''"]$' # Strip quotations. Necessary?
    $destDir = $destDir -replace '[\/]$' # Remove any slashes from end of line
    if (-not ($destDir.EndsWith($versPath))) {
        # installer will not run outside folder vim90
        $destDir = Join-Path -Path $destDir -ChildPath $versPath
    }
}

# Optionally restart explorer before install
if ($pp['RestartExplorer']) {
    Write-Debug "Restarting Explorer."
    Get-Process -Name 'explorer' | Stop-Process -Force
}

# Create batch files in C:\Windows by default
if ($pp['NoCreateBatFiles']) {
    Write-Debug 'Not installing batch files.'
    $createBatFiles = $null
}

# Do not install context menu entry by default
if ($pp['InstallPopUp']) {
    Write-Debug 'Installing context menu entry.'
    $installPopUp = '-install-popup'
}

$baseArgs = "-install-openwith -add-start-menu"
$installArgs = $installPopUp, $createBatFiles, $baseArgs -ne $null -join ' '

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
#    fileFullPath   = $filename32
    fileFullPath64 = $filename64
    destination    = $destDir
}

Get-ChocolateyUnzip @packageArgs

# Supplied manifest fixes useless UAC request
Move-Item -Path "$toolsDir\patch.exe.manifest" -Destination $destDir -Force -ErrorAction SilentlyContinue
(Get-Item $destdir\patch.exe).LastWriteTime = (Get-Date) # exe must be newer than manifest

# Run vim's installer
Move-Item -Path "$toolsDir\install.exe" -Destination "$destDir\install.exe" -Force -ErrorAction SilentlyContinue # vim-tux removed the installer, just in time for Defender to stop flagging it
Move-Item -Path "$toolsDir\uninstall.exe" -Destination "$destDir\uninstall.exe" -Force -ErrorAction SilentlyContinue # vim-tux removed the uninstaller, just in time for Defender to stop flagging it
Start-ChocolateyProcessAsAdmin -Statements "$installArgs" -ExeToRun "$destDir\install.exe" -ValidExitCodes '0' | Out-Null
#$filename32, 
$filename64 | Remove-Item -Force -ErrorAction SilentlyContinue
Write-Host 'Build provided by TuxProject.de - consider donating to help support their server costs.'
