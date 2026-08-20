$ErrorActionPreference = 'Stop'

$DisplayName = 'Adobe Acrobat'

# all checksum types are the same
$allChecksumType = 'SHA256'

$MUIurl = 'https://ardownload3.adobe.com/pub/adobe/reader/win/AcrobatDC/2600121529/AcroRdrDC2600121529_MUI.exe'
$MUIchecksum = 'A6720AC06A472DFBFF4D6B294899D9F2EE050AFAF96FAA7374B42C6B7149F8D6'

$MUIurl64 = 'https://ardownload3.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2600121529/AcroRdrDCx642600121529_MUI.exe'
$MUIchecksum64 = '5B830C22C81899C8AF581AF2F6DC041FF28DD64DD897FA5FAB1D9C012CEAD3EF'

$MUImspURL = 'https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2600121529/AcroRdrDCUpd2600121529_MUI.msp'
$MUImspChecksum = '223875F11E86573FBE68F39A5FC36DD0EFE15A78A3DD2F1B1819A58552133A3C'

$MUImspURL64 = 'https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2600121529/AcroRdrDCx64Upd2600121529_MUI.msp'
$MUImspChecksum64 = '69353E1BD95C3F5AEBCFB47351742B363669E645DC1A0A2FF613CD271EFDD54D'

$MUIinstalled = $false
$PerformNewInstall = $false
$ApplyPatch = $false
[array]$installationFound = Get-UninstallRegistryKey -SoftwareName $DisplayName.replace(' Acrobat', ' Acrobat*')

$MUImspURL -match 'AcroRdrDCUpd(\d+)_' | Out-Null
$UpdaterVersion = $Matches[1]

$PackageParameters = Get-PackageParameters

##
# Ignore Installed Adobe Acrobat Installations
##
# this parameter _could_ cause issues so lets put lots of verbose text around it
if ($PackageParameters['IgnoreInstalled']) {
   if ([string]::IsNullOrEmpty($PackageParameters['IgnoreInstalled']) -or [string]::IsNullOrWhiteSpace($PackageParameters['IgnoreInstalled'])) {
      throw "Package parameter '/IgnoreInstalled' cannot be empty or contain only whitespace."
   }

   # the string passwed to /IgnoreInstalled should be a comma delimited string
   # split it up so we have a list of software to be ignored
   $installationToIgnore = ($PackageParameters['IgnoreInstalled']).Split(',')

   Write-Verbose "/IgnoreInstalled package parameter was passed with these software names:"
   $installationToIgnore | ForEach-Object { Write-Verbose "- $_" }

   # loop over each found installation and ignore it if it matches a value in '/IgnoreInstalled'
   $installationToProcess = for ($i = 0; $i -lt $installationFound.count; $i++) {
      $keep = $false
      for ($j = 0; $j -lt $installationToIgnore.count; $j++) {
         if ($installationFound[$i].DisplayName -notlike $installationToIgnore[$j]) {
            $keep = $true
            Write-Verbose "Keeping '$($installationFound[$i].DisplayName)' as it does not match '$($installationToIgnore[$j])'"
         }
         else {
            Write-Verbose "Removing '$($installationFound[$i].DisplayName)' from list of found software, as it matches '$($installationToIgnore[$j])'"
            # we have found this in the software list so we don't need to keep checking
            # break out of hte loop and start with the next found software
            break
         }
      }

      if ($keep) {
         $installationFound[$i]
      }
   }

   Write-Verbose "After processing, we will use this list of installed software:"
   $installationToProcess | ForEach-Object {
      Write-Warning "- $($_.DisplayName)"
   }

   if ($installation.Count -gt 0 -and $installationToProcess.Count -eq 0) {
      Write-Warning "We originally found $($installationFound.Count) software names matching $($DisplayName.replace(' Acrobat', ' Acrobat*'))."
      Write-Warning 'Using ''/IgnoreInstalled'' matches, this is now 0.'
      Write-Warning 'This may be intended.'
      Write-Warning "This will cause issues if you have the software from this package already installed."
   }
}
else {
   $installationToProcess = $installation
}

if ($installationToProcess.Count -eq 1) {
   $InstalledVersion = $installationToProcess[0].DisplayVersion.replace('.', '')
   $IsAdobeAcrobatReader = $installationToProcess[0].DisplayName -match 'Adobe Acrobat Reader'
   if ($IsAdobeAcrobatReader -and $installationToProcess[0].DisplayName -notmatch 'MUI') {
      if (($InstalledVersion -ge $UpdaterVersion) -and !($PackageParameters.OverwriteInstallation)) {
         Write-Warning "The currently installed $($installationToProcess[0].DisplayName) is a single-language install."
         Write-Warning "You will need to uninstall $($installationToProcess[0].DisplayName) first or use /OverwriteInstallation."
         Throw 'Installation halted.'
      }
      elseif (($InstalledVersion -ge $UpdaterVersion) -and $PackageParameters.OverwriteInstallation) {
         Write-Warning "The currently installed $($installationToProcess[0].DisplayName) is a single-language install."
         Write-Warning  'This package will replace it with the multi-language (MUI) release (Installation overwrite).'
      }
      else {
         Write-Warning "The currently installed $($installationToProcess[0].DisplayName) is a single-language install."
         Write-Warning  'This package will replace it with the multi-language (MUI) release.'
      }
   }
   else {
      $MUIinstalled = $true
      if ($InstalledVersion -eq $UpdaterVersion) {
         Write-Verbose 'Currently installed version is the same as this package.  Nothing further to do.'
         Return
      }
      elseif ($InstalledVersion -gt $UpdaterVersion) {
         Write-Warning "$($installationToProcess[0].DisplayName) v20$($installationToProcess[0].DisplayVersion) installed."
         Write-Warning "This package installs v$($env:ChocolateyPackageVersion) and cannot replace a newer version."
         Throw 'Installation halted.'
      }
      else {
         # for installations where there is an e.g. existing "Adobe Acrobat Reader DC MUI" present,
         # we perform a new installation otherwise we apply the patch
         if ($IsAdobeAcrobatReader) {
            $PerformNewInstall = $true
         }
         else {
            $ApplyPatch = $true
         }
      }
   }
}
elseif ($installationToProcess.count -gt 1) {
   Write-Warning "$($installationToProcess.Count) matching installs of Adobe Acrobat Reader DC found!"
   Write-Warning 'To prevent accidental data loss, this install will be aborted.'
   Write-Warning 'The following installs were found:'
   $installationToProcess | ForEach-Object { Write-Warning "- Name: $($_.DisplayName)`tVersion: $($_.DisplayVersion)" }

   if ($PackageParameters['IgnoreInstalled']) {
      Write-Warning "You have passed '/IgnoreInstalled' containing:"
      ($PackageParameters['IgnoreInstalled']).Split(',') | ForEach-Object { Write-Warning "- $_" }
   }
   Throw 'Installation halted.'
}
else {
   $PerformNewInstall = $true
}

if ($PackageParameters.OverwriteInstallation) {
   Write-Host 'Uninstalling single language version.'
   $UninstallRegKey = [array](Get-UninstallRegistryKey "Adobe Acrobat Reader DC*")[0].UninstallString.split("/I")[2]
   $MSIArgs = @(
      "/x"
      '"{0}"'
      "/qn"
   ) -f $UninstallRegKey
   Start-Process "msiexec.exe" -ArgumentList $MSIArgs -Wait
   $Uninstalled = $?
   $RegPath = 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'

   if (Test-Path $RegPath) {
      $installationToProcess = Get-ItemProperty -path $RegPath
      if ($installationToProcess.bUpdater -ne $null) {
         $null = Remove-ItemProperty -Path $RegPath -Name 'bUpdater' -Force
      }
   }

   if ($Uninstalled) {
      Write-Host "Successfully uninstalled existing Adobe Acrobat Reader."
   }
   else {
      Throw "Failed to uninstall existing version of Adobe Acrobat Reader."
   }
}

# Reference: https://www.adobe.com/devnet-docs/acrobatetk/tools/AdminGuide/properties.html#command-line-example
$options = ' DISABLEDESKTOPSHORTCUT=1'
if ($PackageParameters.DesktopIcon) {
   $options = ''
   Write-Host 'You requested a desktop icon.' -ForegroundColor Cyan
}

if ($PackageParameters.NoUpdates) {
   $RegRoot = 'HKLM:\SOFTWARE\Policies'
   $RegSubFolders = ('Adobe\Acrobat Reader\DC\FeatureLockDown').split('\')
   for ($i = 0; $i -lt $RegSubFolders.count; $i++) {
      $RegPath = "$RegRoot\$($RegSubFolders[0..$i] -join '\')"
      if (-not (Test-Path $RegPath)) {
         $null = New-Item -Path $RegPath.TrimEnd($RegSubFolders[$i]) -Name $RegSubFolders[$i]
      }
   }
   $RegPath = "$RegRoot\$($RegSubFolders -join '\')"
   if (Test-Path $RegPath) {
      $null = New-ItemProperty -Path $RegPath -Name 'bUpdater' -PropertyType DWORD -Value 0 -Force
   }
   Write-Host 'You requested no Adobe updates.' -ForegroundColor Cyan
}

if ($PackageParameters.EnableUpdateService) {
   Write-Host 'You requested to enable the auto-update service.' -ForegroundColor Cyan
   if ($MUIinstalled) {
      if (Get-Service -Name 'AdobeARMservice' -ErrorAction SilentlyContinue) {
         $null = Set-Service -Name 'AdobeARMservice' -StartupType Automatic
         $null = Start-Service -Name 'AdobeARMservice'
      }
      else {
         Write-Warning 'The Adobe ARM update service is not available and is not installed on updates.'
      }
   }
}
else {
   $options += ' DISABLE_ARM_SERVICE_INSTALL=1'
   if (Get-Service -Name 'AdobeARMservice' -ErrorAction SilentlyContinue) {
      $null = Stop-Service -Name 'AdobeARMservice' -Force
      $null = Set-Service -Name 'AdobeARMservice' -StartupType Disabled
   }
}

if (-not $PackageParameters.UpdateMode) {
   $UpdateMode = 0
}
else { $UpdateMode = $PackageParameters.UpdateMode }

if ((0..4) -contains $UpdateMode) {
   Switch ($UpdateMode) {
      0 { Write-Host 'Configuring manual update checks and installs.' -ForegroundColor Cyan }
      1 { Write-Host 'You requested manual update checks and installs.' -ForegroundColor Cyan }
      2 { Write-Host 'You requested automatic update downloads and manual installs.' -ForegroundColor Cyan }
      3 { Write-Host 'You requested scheduled, automatic updates.' -ForegroundColor Cyan }
      4 { Write-Host 'You requested notifications but manual updates.' -ForegroundColor Cyan }
   }
   if ($MUIinstalled) {
      # This is the official setting based on the reference URL.
      $RegPath1 = 'HKLM:\SOFTWARE\Adobe\Adobe ARM\1.0\ARM\'
      if (Test-Path $RegPath1) {
         $null = New-ItemProperty -Path $RegPath1 -Name 'iCheckReader' -Value $UpdateMode -force
      }
      $GUID = '{' + $installationToProcess[0].UninstallString.split('{')[-1]
      # This is the setting that actually causes a change in behavior.
      $RegPath2 = "HKLM:\SOFTWARE\Wow6432Node\Adobe\Adobe ARM\Legacy\Reader\$GUID"
      if (Test-Path $RegPath2) {
         $null = New-ItemProperty -Path $RegPath2 -Name 'Mode' -Value $UpdateMode -force
      }
   }
   else {
      $options += " UPDATE_MODE=$UpdateMode"
   }
}

if ($PerformNewInstall) {
   $DownloadArgs = @{
      packageName         = $env:ChocolateyPackageName
      FileFullPath        = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.installer.exe"
      url                 = $MUIurl
      checksum            = $MUIChecksum
      checksumType        = $allChecksumType
      url64bit            = $MUIurl64
      checksum64          = $MUIChecksum64
      checksumType64      = $allChecksumType
      GetOriginalFileName = $true
   }
   $MUIexePath = Get-ChocolateyWebFile @DownloadArgs

   $packageArgsEXE = @{
      packageName    = "$env:ChocolateyPackageName (installer)"
      fileType       = 'EXE'
      File           = $MUIexePath
      checksumType   = $allChecksumType
      silentArgs     = "/sAll /msi /norestart /quiet PATCH=`"$mspPath`" ALLUSERS=1 EULA_ACCEPT=YES $options" +
      " /L*v `"$env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Install.log`""
      validExitCodes = @(0, 1000, 1101, 1603)
   }
   $exitCode = Install-ChocolateyInstallPackage @packageArgsEXE

   # check if the patch should be applied separately
   [array]$installationToProcess = Get-UninstallRegistryKey -SoftwareName $DisplayName.replace(' Acrobat', ' Acrobat*')
   $InstalledVersion = $installationToProcess[0].DisplayVersion.replace('.', '')
   $ApplyPatch = $InstalledVersion -lt $UpdaterVersion

   if ($exitCode -eq 1603) {
      Write-Warning "For code 1603, Adobe recommends to 'shut down Microsoft Office and all web browsers' and try again."
      Write-Warning 'The install log should provide more details about the encountered issue:'
      Write-Warning "   $env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Install.log"
      Throw "Installation of $env:ChocolateyPackageName was unsuccessful."
   }
}

if ($ApplyPatch) {
   $DownloadArgs = @{
      packageName         = "$env:ChocolateyPackageName (update)"
      FileFullPath        = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.msp"
      url                 = $MUImspURL
      checksum            = $MUImspChecksum
      checksumType        = $allChecksumType
      url64bit            = $MUImspURL64
      checksum64          = $MUImspChecksum64
      checksumType64      = $allChecksumType
      GetOriginalFileName = $true
   }
   $mspPath = Get-ChocolateyWebFile @DownloadArgs

   Write-Host 'Applying patch.'
   $UpdateArgs = @{
      Statements     = "/p `"$mspPath`" /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES $options" +
      " /L*v `"$env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Update.log`""
      ExetoRun       = 'msiexec.exe'
      validExitCodes = @(0, 1603, 3010)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @UpdateArgs

   if ($exitCode -eq 1603) {
      Write-Warning "For code 1603, Adobe recommends to 'shut down Microsoft Office and all web browsers' and try again."
      Write-Warning 'The update log should provide more details about the encountered issue:'
      Write-Warning "   $env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Update.log"
      Throw "Patching of $env:ChocolateyPackageName to the latest version was unsuccessful."
   }
}

if ($PackageParameters.NoUpdates -or $UpdateMode -lt 2) {
   Unregister-ScheduledTask 'Adobe Acrobat Update Task' -Confirm:$false -ErrorAction SilentlyContinue
}
