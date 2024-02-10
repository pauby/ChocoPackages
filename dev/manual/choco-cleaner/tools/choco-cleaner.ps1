$ErrorActionPreference = 'Continue'
#Requires -RunAsAdministrator
# Choco-Cleaner.ps1 Copyleft 2017-2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

Write-Host "Choco-Cleaner.ps1 v1.1.2 PRE (2023-07-21) - deletes unnecessary residual Chocolatey files to free up disk space" -Foreground White
Write-Host "Copyleft 2017-2023 Bill Curran (bcurran3@yahoo.com) - free for personal and commercial use`n" -Foreground White

# Verify ChocolateyToolsLocation was created by Get-ToolsLocation during install and is in the environment
if (!($ENV:ChocolateyToolsLocation)) {$ENV:ChocolateyToolsLocation = "$ENV:SystemDrive\tools"}
if (!(Test-Path "$ENV:ChocolateyToolsLocation\BCURRAN3")) {Write-Warning "Configuration file not found. Please re-install."; throw}

# Set Notepad++ as preferred editor/viewer
if (Test-Path $ENV:ChocolateyInstall\bin\notepad++.exe){
	$Editor="notepad++.exe"
}else {
	$Editor="notepad.exe"
}

# Easily edit the config file
if ($args -eq "-EditConfig"){
	Write-Host "  ** Editing contents of choco-cleaner.config." -Foreground Magenta
	&$Editor "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.config"
	return
}

# Easily edit the CCRT config file
if ($args -eq "-EditConfigRT"){
	Write-Host "  ** Editing contents of choco-cleaner-rt.config." -Foreground Magenta
	&$Editor "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner-rt.config"
	return
}

# Easily view the log file
if ($args -eq "-ViewLog"){
	Write-Host "  ** Showing contents of choco-cleaner.log." -Foreground Magenta
	&$Editor "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"
	return
}

# Easily view the CCRT log file
if ($args -eq "-ViewLogRT"){
	Write-Host "  ** Showing contents of choco-cleaner-rt.log." -Foreground Magenta
	&$Editor "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner-rt.log"
	return
}

##### VARIABLES BEGIN

# All 7Zip supported formats plus EXE, MSU, MSP, APPX, APPXBUNDLE, IMG - Is anything else needed?
$BinaryExtensions=@(
	"*.exe","*.img","*.msu","*.msp","*.appx","*.appxbundle","*.7z","*.xz",
	"*.bzip2","*.gzip","*.tar","*.zip","*.wim","*.ar","*.arj","*.cab","*.chm",
	"*.cpio","*.cramfs","*.dmg","*.ext","*.fat","*.gpt","*.hfs","*.ihex",
	"*.iso","*.lzh","*.lzma","*.mbr","*.msi","*.nsis","*.ntfs","*.qcow2",
	"*.rar","*.rpm","*.squashfs","*.udf","*.uefi","*.vdi","*.vhd","*.vmdk",
	"*.xar","*.z","*.dll"
)

# All log file types
$file_log_types = @(
	"*.zip.txt","*.exe.txt","*.rar.txt","*.7z.txt","*.gz.txt","*.tar.txt",
	"*.sfx.txt","*.iso.txt"
)

# All temporary archive types
$archive_types = @(
	"*.zip","*.rar","*.7z","*.gz","*.tar","*.sfx","*.iso","*.img","*.appx",
	"*.appxbundle","*.bzip2","*.gzip","*.tar","*.lzh","*.z"
)

# All license text types
$license_types = @( "license.txt","*.license.txt","verification.txt" )

# All embedded installer types
$embed_types = @( "*.msi","*.msu","*.msp" )

# All readme types
$readme_types = @( "credits.txt","readme.txt","*.md" )

# global tracking and reporting variables
$global:CCExitCode=0
$global:global:DeletedFiles=0
$global:PermissionErrors=$False
$global:Reclaimed=0

# Import preferences from choco-cleaner.config
[xml]$ConfigFile = Get-Content "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.config"
if ($ConfigFile.Settings.Preferences.DeleteLogs -eq "true") {$DeleteLogs=$True} else {$DeleteLogs=$False}
if ($ConfigFile.Settings.Preferences.DeleteArchives -eq "true") {$DeleteArchives=$True} else {$DeleteArchives=$False}
if ($ConfigFile.Settings.Preferences.DeleteFileLogs -eq "true") {$DeleteFileLogs=$True} else {$DeleteFileLogs=$False}
if ($ConfigFile.Settings.Preferences.DeleteMSInstallers -eq "true") {$DeleteMSInstallers=$True} else {$DeleteMSInstallers=$False}
if ($ConfigFile.Settings.Preferences.DeleteIgnoreFiles -eq "true") {$DeleteIgnoreFiles=$True} else {$DeleteIgnoreFiles=$False}
if ($ConfigFile.Settings.Preferences.DeleteReadmes -eq "true") {$DeleteReadmes=$True} else {$DeleteReadmes=$False}
if ($ConfigFile.Settings.Preferences.DeleteOldChoco -eq "true") {$DeleteOldChoco=$True} else {$DeleteOldChoco=$False}
if ($ConfigFile.Settings.Preferences.DeleteConfigBackupFile -eq "true") {$DeleteConfigBackupFile=$True} else {$DeleteConfigBackupFile=$False}
if ($ConfigFile.Settings.Preferences.DeleteLibBad -eq "true") {$DeleteLibBad=$True} else {$DeleteLibBad=$False}
if ($ConfigFile.Settings.Preferences.DeleteLibBkp -eq "true") {$DeleteLibBkp=$True} else {$DeleteLibBkp=$False}
if ($ConfigFile.Settings.Preferences.DeleteLibSynced -eq "true") {$DeleteLibSynced=$True} else {$DeleteLibSynced=$False}
if ($ConfigFile.Settings.Preferences.Optimizenupkg -eq "true") {$Optimizenupkg=$True} else {$Optimizenupkg=$False}
if ($ConfigFile.Settings.Preferences.DeleteCache -eq "true") {$DeleteCache=$True} else {$DeleteCache=$False}
if ($ConfigFile.Settings.Preferences.DeleteLicenseFiles -eq "true") {$DeleteLicenseFiles=$True} else {$DeleteLicenseFiles=$False}
if ($ConfigFile.Settings.Preferences.DeleteNuGetCache -eq "true") {$DeleteNuGetCache=$True} else {$DeleteNuGetCache=$False}
if ($ConfigFile.Settings.Preferences.DeleteBadShims -eq "true") {$DeleteBadShims=$True} else {$DeleteBadShims=$False}
if ($ConfigFile.Settings.Preferences.DeleteDotChocolatey -eq "true") {$DeleteDotChocolatey=$True} else {$DeleteDotChocolatey=$False}

# Import chocolatey.config and get cacheLocation if set
[xml]$ChocoConfigFile = Get-Content "$ENV:ChocolateyInstall\config\chocolatey.config"
$cacheLocation = $ChocoConfigFile.chocolatey.config | ForEach-Object { $_.add } | Where-Object { $_.key -eq 'cacheLocation' } | Select-Object -Expand value

##### VARIABLES END
##### HELPER FUNCTIONS BEGIN

# add to log file
function Add2Log {
    Param ( [string]$comment )

    Write-Output "$(Get-Date) [INFO ] $comment" >> "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"
}

# add to log file and display error
function Add2LogError {
    Param ( [string]$comment )

    Write-Host "  ** [ERROR] $comment" -Foreground Red
    Write-Output "$(Get-Date) [ERROR] $comment" >> "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"
	$global:CCExitCode=1
}

# run shim and report if the target program exists or not
function Test-ShimTargetExists {
	Param ( [Object][Parameter(Mandatory=$true, ValueFromPipeline=$true)]$ShimFile )

	$TargetExists = & "$ShimFile" "--shimgen-help" |
					 Select-String -pattern "Target Exists: 'True'"
	if (-not $TargetExists) {
		Return $false
	} else {
		Return $true
	}
}

##### HELPER FUNCTIONS END
##### MAIN FUNCTIONS BEGIN

# Deletes _processed.txt
function DelProcessedTxt {
if (Test-Path $ENV:ChocolateyInstall\bin\_processed.txt){
	Write-Host "  ** Deleting unnecessary Chocolatey _processed.txt (WTF?) file..." -Foreground Green
	Remove-Item -Path $ENV:ChocolateyInstall\bin\_processed.txt -ErrorAction SilentlyContinue
	if ($error[0].categoryinfo.category -match "PermissionDenied") {
		$global:PermissionErrors=$True
		Add2LogError "deleting unnecessary Chocolatey _processed.txt file due to permissions."
	} else {
	    $global:global:DeletedFiles=$global:global:DeletedFiles + 1
	}
}
}

# Deletes .ignore files
function DeleteIgnoreFiles {
	$IgnoreFilesSize=0
	$GotIgnoreFiles=Get-ChildItem -Path $ENV:ChocolateyInstall\lib -Recurse -Include *.ignore -ErrorAction SilentlyContinue
	if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
		$ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
	}
	$IgnoreFiles=$GotIgnoreFiles.count
	if ($IgnoreFiles -ge 1){
		Write-Host "  ** Deleting $IgnoreFiles unnecessary Chocolatey .ignore files..." -Foreground Green
		$GotIgnoreFiles | ForEach-Object {$IgnoreFilesSize=$IgnoreFilesSize + $_.length}
		Remove-Item -Path $ENV:ChocolateyInstall -Recurse -Include *.ignore -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		$global:PermissionErrors=$True
	    	Add2LogError "deleting unnecessary Chocolatey .ignore files due to permissions."
	    } else {
			$GotIgnoreFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			Add2Log "RECLAIMED: $IgnoreFilesSize bytes"
			$global:global:DeletedFiles=$global:global:DeletedFiles + $IgnoreFiles
			$global:Reclaimed=$global:Reclaimed + $IgnoreFilesSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey .ignore files to delete." -Foreground Green
	}
}

# Deletes Chocolatey .old files
function DeleteOldChoco {
	$GotOldChocoSize=0
	$GotOldChoco=Get-ChildItem -Path $ENV:ChocolateyInstall -Recurse -Include *.old -ErrorAction SilentlyContinue
	if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
		$ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
		}
	$OldChoco=$GotOldChoco.count
	if ($OldChoco -ge 1){
		Write-Host "  ** Deleting $OldChoco unnecessary Chocolatey .old files..." -Foreground Green
		$GotOldChoco | ForEach-Object {$GotOldChocoSize=$GotOldChocoSize + $_.length}
		Remove-Item -Path $ENV:ChocolateyInstall -Recurse -Include *.old -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		$global:PermissionErrors=$True
	    	Add2LogError "deleting Chocolatey .old files due to permissions."
	    } else {
			$GotOldChoco.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			Add2Log "RECLAIMED: $GotOldChocoSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $OldChoco
			$global:Reclaimed=$global:Reclaimed + $GotOldChocoSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey .old files to delete." -Foreground Green
	}
}

# Deletes Chocolatey cache files in multiple locations
function DeleteCache {
	$UserDirs=Get-ChildItem -Path C:\Users -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName
	for ($Count = 0; $Count -lt $UserDirs.FullName.Count; $Count++){
		$GotCacheFilesSize=0
		$dir = $userdirs.fullname[$Count]
		$dir = "$dir" + "\appdata\local\temp\chocolatey"
    	$GotCacheFiles=Get-ChildItem -Path $dir -Recurse -ErrorAction SilentlyContinue
	    $CacheFiles=$GotCacheFiles.count
	    if ($CacheFiles -ge 1){
		    Write-Host "  ** Deleting $CacheFiles unnecessary Chocolatey cache files ($dir)..." -Foreground Green
		    $GotCacheFiles | ForEach-Object {$GotCacheFilesSize=$GotCacheFilesSize + $_.length}
		    Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
	        if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		    $global:PermissionErrors=$True
	    	    Add2LogError "deleting unnecessary Chocolatey cache files ($dir) due to permissions."
	    } else {
			$GotCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			Add2Log "RECLAIMED: $GotCacheFilesSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $CacheFiles
			$global:Reclaimed=$global:Reclaimed + $GotCacheFilesSize
		}
	    } else {
		  Write-Host "  ** NO unnecessary Chocolatey cache files ($dir) to delete." -Foreground Green
	    }
    }

	$GotCacheFiles=Get-ChildItem -Path $ENV:SystemRoot\temp\chocolatey -Recurse -ErrorAction SilentlyContinue
	if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
		$ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
		}
	$CacheFiles=$GotCacheFiles.count
	if ($CacheFiles -ge 1){
		$GotCacheFilesSize=0
		Write-Host "  ** Deleting $CacheFiles unnecessary Chocolatey cache files ($ENV:SystemRoot\temp\chocolatey)..." -Foreground Green
	    $GotCacheFiles | ForEach-Object {$GotCacheFilesSize=$GotCacheFilesSize + $_.length}
		Remove-Item -Path $ENV:SystemRoot\temp\chocolatey -Recurse -Force -ErrorAction SilentlyContinue
        if ($error[0].categoryinfo.category -match "PermissionDenied") {
   		    $global:PermissionErrors=$True
    	    Add2LogError "deleting unnecessary Chocolatey cache files ($ENV:SystemRoot\temp\chocolatey) due to permissions."
	    } else {
			$GotCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			Add2Log "RECLAIMED: $GotCacheFilesSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $CacheFiles
			$global:Reclaimed=$global:Reclaimed + $GotCacheFilesSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey cache files ($ENV:SystemRoot\temp\chocolatey) to delete." -Foreground Green
	}

	if ($cacheLocation){
		$GotCacheFilesSize=0
		if (Test-Path $cacheLocation) {
			$GotCacheFiles=Get-ChildItem -Path $cacheLocation -Recurse -ErrorAction SilentlyContinue
	        if ($error[0].categoryinfo.category -match "PermissionDenied") {
                $global:PermissionErrors=$True
		        $ErrorPath=$error[0].categoryinfo.targetname
	            Add2LogError "reading $ErrorPath due to permissions."
		    }
			$CacheFiles=$GotCacheFiles.count
			if ($CacheFiles -ge 1){
				Write-Host "  ** Deleting $CacheFiles unnecessary Chocolatey cache files ($cacheLocation)..." -Foreground Green
	            $GotCacheFiles | ForEach-Object {$GotCacheFilesSize=$GotCacheFilesSize + $_.length}
				Remove-Item -Path $GotCacheFiles.fullname -Recurse -Force -ErrorAction SilentlyContinue
	            if ($error[0].categoryinfo.category -match "PermissionDenied") {
      		        $global:PermissionErrors=$True
	    	        Add2LogError "deleting unnecessary Chocolatey cache files ($cacheLocation) due to permissions."
	            } else {
			       $GotCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			       Add2Log "RECLAIMED: $GotCacheFilesSize bytes"
			       $global:DeletedFiles=$global:DeletedFiles + $CacheFiles
			       $global:Reclaimed=$global:Reclaimed + $GotCacheFilesSize
		        }
			} else {
				Write-Host "  ** NO unnecessary Chocolatey cache files ($cacheLocation) to delete." -Foreground Green
			}
		}
	}
}

# Deletes NuGet cache files
function DeleteNuGetCache {
	$UserDirs=Get-ChildItem -Path C:\Users -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName
	for ($Count = 0; $Count -lt $UserDirs.FullName.Count; $Count++){
		$GotNuGetCacheSize=0
		$dir = $userdirs.fullname[$Count]
		$dir = "$dir" + "\appdata\Local\Nuget\Cache"
		$GotNuGetCache=Get-ChildItem -Path $dir -Recurse -ErrorAction SilentlyContinue
		$NuGetCache=$GotNuGetCache.count
		if ($NuGetCache -ge 1){
			Write-Host "  ** Deleting $NuGetCache unnecessary Nuget cache files ($dir)..." -Foreground Green
	        $GotNuGetCache | ForEach-Object {$GotNuGetCacheSize=$GotNuGetCacheSize + $_.length}
		    Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
	        if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		    $global:PermissionErrors=$True
	    	    Add2LogError "deleting unnecessary Nuget cache files ($dir) due to permissions."
	        } else {
			    $GotNuGetCache.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			    Add2Log "RECLAIMED: $GotNuGetCacheSize bytes"
			    $global:DeletedFiles=$global:DeletedFiles + $NuGetCache
			    $global:Reclaimed=$global:Reclaimed + $GotNuGetCacheSize
		    }
		} else {
			Write-Host "  ** NO unnecessary Nuget cache files ($dir) to delete." -Foreground Green
		}
	}
}

# Deletes chocolatey.config.backup
function DeleteConfigBackupFile {
	if (Test-Path $ENV:ChocolateyInstall\config\chocolatey.config.backup){
		Write-Host "  ** Deleting unnecessary Chocolatey config backup file..." -Foreground Green
		Remove-Item -Path $ENV:ChocolateyInstall\config\chocolatey.config.backup -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    	   $global:PermissionErrors=$True
	       Add2LogError "deleting unnecessary Chocolatey config backup file due to permissions."
	    } else {
		    Add2Log "DELETED: $ENV:ChocolateyInstall\config\chocolatey.config.backup"
			$global:DeletedFiles=$global:DeletedFiles + 1
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey config backup file to delete." -Foreground Green
	}
}

# Deletes files in lib-bad
function DeleteLibBad {
	$GotLibBadFilesSize=0
	if (Test-Path $ENV:ChocolateyInstall\lib-bad){
		$GotLibBadFiles=Get-ChildItem -Path $ENV:ChocolateyInstall\lib-bad -Recurse
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
            $global:PermissionErrors=$True
		    $ErrorPath=$error[0].categoryinfo.targetname
	        Add2LogError "reading $ErrorPath due to permissions."
		}
		$LibBadFiles=$GotLibBadFiles.count
		if ($LibBadFiles -ge 1){
			Write-Host "  ** Deleting $LibBadFiles unnecessary Chocolatey lib-bad package files..." -Foreground Green
	        $GotLibBadFiles | ForEach-Object {$GotLibBadFilesSize=$GotLibBadFilesSize + $_.length}
		    Remove-Item -Path $GotLibBadFiles.fullname -Recurse -Force -ErrorAction SilentlyContinue
	        if ($error[0].categoryinfo.category -match "PermissionDenied") {
    	       $global:PermissionErrors=$True
	           Add2LogError "deleting unnecessary Chocolatey lib-bad files due to permissions."
	        } else {
			    $GotLibBadFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			    Add2Log "RECLAIMED: $GotLibBadFilesSize bytes"
			    $global:DeletedFiles=$global:DeletedFiles + $LibBadFiles
			    $global:Reclaimed=$global:Reclaimed + $GotLibBadFilesSize
		    }
		} else {
			Write-Host "  ** NO unnecessary Chocolatey lib-bad package files to delete." -Foreground Green
		}
	}
}

# Deletes files in lib-bkp
function DeleteLibBkp {
	$GotLibBkpFilesSize=0
	if (Test-Path $ENV:ChocolateyInstall\lib-bkp){
		$GotLibBkpFiles=Get-ChildItem -Path $ENV:ChocolateyInstall\lib-bkp -Recurse
        if ($error[0].categoryinfo.category -match "PermissionDenied") {
            $global:PermissionErrors=$True
            $ErrorPath=$error[0].categoryinfo.targetname
	        Add2LogError "reading $ErrorPath due to permissions."
	    }
		$LibBkpFiles=$GotLibBkpFiles.count
		if ($LibBkpFiles -ge 1){
			Write-Host "  ** Deleting $LibBkpFiles unnecessary Chocolatey lib-bkp package files..." -Foreground Green
	        $GotLibBkpFiles | ForEach-Object {$GotLibBkpFilesSize=$GotLibBkpFilesSize + $_.length}
		    Remove-Item -Path $GotLibBkpFiles.fullname -Recurse -Force -ErrorAction SilentlyContinue
	        if ($error[0].categoryinfo.category -match "PermissionDenied") {
    	       $global:PermissionErrors=$True
	           Add2LogError "deleting unnecessary Chocolatey lib-bkp files due to permissions."
	        } else {
			    $GotLibBkpFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			    Add2Log "RECLAIMED: $GotLibBkpFilesSize bytes"
			    $global:DeletedFiles=$global:DeletedFiles + $LibBkpFiles
			    $global:Reclaimed=$global:Reclaimed + $GotLibBkpFilesSize
		    }
		} else {
			Write-Host "  ** NO unnecessary Chocolatey lib-bkp package files to delete." -Foreground Green
		}
	}
}

# Deletes files in lib-synced
function DeleteLibSynced {
	$GotLibSyncedFilesSize=0
	if (Test-Path $ENV:ChocolateyInstall\lib-synced){
		$GotLibSyncedFiles=Get-ChildItem -Path $ENV:ChocolateyInstall\lib-synced -Recurse
        if ($error[0].categoryinfo.category -match "PermissionDenied") {
            $global:PermissionErrors=$True
            $ErrorPath=$error[0].categoryinfo.targetname
	        Add2LogError "reading $ErrorPath due to permissions."
	    }
		$LibSyncedFiles=$GotLibSyncedFiles.count
		if ($LibSyncedFiles -ge 1){
			Write-Host "  ** Deleting $LibSyncedFiles unnecessary Chocolatey lib-synced package files..." -Foreground Green
	        $GotLibSyncedFiles | ForEach-Object {$GotLibSyncedFilesSize=$GotLibSyncedFilesSize + $_.length}
		    Remove-Item -Path $GotLibSyncedFiles.fullname -Recurse -Force -ErrorAction SilentlyContinue
	        if ($error[0].categoryinfo.category -match "PermissionDenied") {
    	       $global:PermissionErrors=$True
	           Add2LogError "deleting unnecessary Chocolatey lib-synced files due to permissions."
	        } else {
			    $GotLibSyncedFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			    Add2Log "RECLAIMED: $GotLibSyncedFilesSize bytes"
			    $global:DeletedFiles=$global:DeletedFiles + $LibSyncedFiles
			    $global:Reclaimed=$global:Reclaimed + $GotLibSyncedFilesSize
		    }
		} else {
			Write-Host "  ** NO unnecessary Chocolatey lib-synced package files to delete." -Foreground Green
		}
	}
}

# Deletes files in the hidden .chocolatey directory
function DeleteDotChocolatey {
	$deltaSize=0
#if (([System.Version]([System.Diagnostics.FileVersionInfo]::GetVersionInfo("$env:chocolateyinstall\choco.exe").ProductVersion)).major -gt 1) {
if ([System.Diagnostics.FileVersionInfo]::GetVersionInfo("$env:chocolateyinstall\choco.exe").ProductMajorPart -gt 1){
	$InstalledPackages = & choco list -r -y
	} else {
		$InstalledPackages = & choco list -lo -r -y
		}
    $InstalledPackages=$InstalledPackages.replace("|",".")
    $DotChocolateyDirs =  Get-ChildItem -Path $env:ChocolateyInstall\.chocolatey\* -Directory -Name
    $delta = $DotChocolateyDirs | Where-Object {$InstalledPackages -NotContains $_}
	$DotChocolateyFiles2Delete=$delta | foreach-object $_ {Get-ChildItem -Path $env:ChocolateyInstall\.chocolatey\$_}
    $DeltaCount=$DotChocolateyFiles2Delete.count
    if ($DeltaCount -ge 1){
	   Write-Host "  ** Deleting $DeltaCount unnecessary Chocolatey .chocolatey install snapshot files..." -Foreground Green
	   $DotChocolateyFiles2Delete | ForEach-Object {$deltaSize=$deltaSize + $_.length}
       Remove-Item $DotChocolateyFiles2Delete.fullname -Recurse -Force # Deletes files but not empty directories
       if ($error[0].categoryinfo.category -match "PermissionDenied") {
 	      $global:PermissionErrors=$True
   	      Add2LogError "deleting .chocolatey install snapshot files due to permissions."
	    } else {
			$delta | % {Remove-Item $env:ChocolateyInstall\.chocolatey\$_ -Recurse -Force}
		    $DotChocolateyFiles2Delete.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			Add2Log "RECLAIMED: $deltaSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $DeltaCount
			$global:Reclaimed=$global:Reclaimed + $deltaSize
		}
	} else {
	   Write-Host "  ** NO unnecessary Chocolatey .chocolatey install snapshot files to delete." -Foreground Green
	}
}

# Deletes package install file logs
function DeleteFileLogs {
	$GotFileLogsSize=0
	$GotFileLogs=Get-ChildItem -Path $ENV:ChocolateyInstall -Recurse -Include $file_log_types -ErrorAction SilentlyContinue
    if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
        $ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
	}
	$FileLogs=$GotFileLogs.count
	if ($FileLogs -ge 1){
		Write-Host "  ** Deleting $FileLogs unnecessary Chocolatey extracted file logs..." -Foreground Green
	    $GotFileLogs | ForEach-Object {$GotFileLogsSize=$GotFileLogsSize + $_.length}
		Remove-Item -Path $ENV:ChocolateyInstall -Recurse -Include $file_log_types -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		$global:PermissionErrors=$True
	    	Add2LogError "deleting unnecessary Chocolatey extracted file logs due to permissions."
	    } else {
		    $GotFileLogs.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			Add2Log "RECLAIMED: $GotFileLogsSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $FileLogs
			$global:Reclaimed=$global:Reclaimed + $GotFileLogsSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey extracted file logs to delete." -Foreground Green
	}
}

# Deletes Chocolatey logs except the most recent one
function DeleteLogs {
	$GotOldLogsSize=0
	$GotOldLogs=Get-ChildItem -Path $ENV:ChocolateyInstall\logs\*.log -Recurse -Exclude chocolatey.log,choco.summary.log -ErrorAction SilentlyContinue
    if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
        $ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
	}
	$FileLogs=$GotOldLogs.count
	if ($FileLogs -ge 1){
		Write-Host "  ** Deleting $FileLogs unnecessary Chocolatey log files..." -Foreground Green
	    $GotOldLogs | ForEach-Object {$GotOldLogsSize=$GotOldLogsSize + $_.length}
		Remove-Item -Path $ENV:ChocolateyInstall\logs\*.log  -Exclude chocolatey.log,choco.summary.log -Recurse -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		$global:PermissionErrors=$True
	    	Add2LogError "deleting unnecessary Chocolatey log files due to permissions."
	    } else {
		    $GotOldLogs.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			Add2Log "RECLAIMED: $GotOldLogsSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $FileLogs
			$global:Reclaimed=$global:Reclaimed + $GotOldLogsSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey log files to delete." -Foreground Green
	}
}

# Deletes archive files left over from package installs
function DeleteArchives {
	$GotArchvieFilesSize=0
	$GotArchvieFiles=Get-ChildItem -Path $ENV:ChocolateyInstall\lib -Recurse -Include $archive_types -ErrorAction SilentlyContinue
    if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
        $ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
	}
	$ArchiveFiles=$GotArchvieFiles.count
	if ($ArchiveFiles -ge 1){
		Write-Host "  ** Deleting $ArchiveFiles unnecessary Chocolatey package embedded archive files in toolsDirs..." -Foreground Green
	    $GotArchvieFiles | ForEach-Object {$GotArchvieFilesSize=$GotArchvieFilesSize + $_.length}
		Remove-Item -Path $ENV:ChocolateyInstall\lib -Recurse -Include $archive_types -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		$global:PermissionErrors=$True
	    	Add2LogError "deleting unnecessary Chocolatey package embedded archive files due to permissions."
	    } else {
		    $GotArchvieFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
			Add2Log "RECLAIMED: $GotArchvieFilesSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $ArchiveFiles
			$global:Reclaimed=$global:Reclaimed + $GotArchvieFilesSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey package embedded archive files in toolsDirs to delete." -Foreground Green
	}
}

# Deletes embedded archives and executables out of package files
function Optimizenupkg {
    $nupkgsSizeBefore=0
    $nupkgsSizeAfter=0
	$Gotnupkgs=(Get-Childitem $ENV:ChocolateyInstall\lib -Recurse -Include *.nupkg -ErrorAction SilentlyContinue)
	$Gotnupkgs | ForEach-Object {$nupkgsSizeBefore=$nupkgsSizeBefore + $_.length}
	Write-Host "  ** Deleting unnecessary Chocolatey package embedded archives and executables in .nupkg files..." -Foreground Green
	$Gotnupkgs | ForEach-Object {
		& $ENV:ChocolateyInstall\tools\7z.exe d -r -tZIP $_ $BinaryExtensions | Out-Null
		if ($LASTEXITCODE) {Add2LogError "optimizing $_"}
	}
	$Gotnupkgs=(Get-Childitem $ENV:ChocolateyInstall\lib -Recurse -Include *.nupkg -ErrorAction SilentlyContinue)
	$Gotnupkgs | ForEach-Object {$nupkgsSizeAfter=$nupkgsSizeAfter + $_.length}
    $nupkgsSpaceFreed=($nupkgsSizeBefore - $nupkgsSizeAfter)
    if ($nupkgsSpaceFreed -gt 0) {
		Add2Log "RECLAIMED: $nupkgsSpaceFreed bytes"
	    $global:Reclaimed=$global:Reclaimed + $nupkgsSpaceFreed
	}
}

# Deletes license files
function DeleteLicenseFiles {
	$GotLicenseFilesSize=0
	$GotLicenseFiles=Get-ChildItem -Path $ENV:ChocolateyInstall\* -Recurse -Include $license_types -Exclude shimgen.license.txt -ErrorAction SilentlyContinue
    if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
        $ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
	}
	$LicenseFiles=$GotLicenseFiles.count
	if ($LicenseFiles -ge 1){
		Write-Host "  ** Deleting $LicenseFiles unnecessary Chocolatey package embedded license files..." -Foreground Green
	    $GotLicenseFiles | ForEach-Object {$GotLicenseFilesSize=$GotLicenseFilesSize + $_.length}
		Remove-Item	-Path $ENV:ChocolateyInstall -Recurse -Include $license_types -Exclude shimgen.license.txt -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		$global:PermissionErrors=$True
	    	Add2LogError "deleting unnecessary Chocolatey package embedded license files due to permissions."
	    } else {
		    $GotLicenseFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
            Add2Log "RECLAIMED: $GotLicenseFilesSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $LicenseFiles
			$global:Reclaimed=$global:Reclaimed + $GotLicenseFilesSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey package embedded license files to delete." -Foreground Green
	}
}

# Deletes MS Installer files from package installs
function DeleteMSInstallers {
	$GotMSInstallersSize=0
	$GotMSInstallers=Get-ChildItem -Path $ENV:ChocolateyInstall\lib -Recurse -Include $embed_types -ErrorAction SilentlyContinue
    if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
        $ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
	}
	$MSInstallers=$GotMSInstallers.count
	if ($MSInstallers -ge 1){
		Write-Host "  ** Deleting $MSInstallers unnecessary Chocolatey package embedded Microsoft installers..." -Foreground Green
	    $GotMSInstallers | ForEach-Object {$GotMSInstallersSize=$GotMSInstallersSize + $_.length}
		Remove-Item -Path $ENV:ChocolateyInstall\lib -Recurse -Include $embed_types -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		$global:PermissionErrors=$True
	    	Add2LogError "deleting unnecessary Chocolatey package embedded Microsoft installer files due to permissions."
	    } else {
		    $GotMSInstallers.fullname | ForEach-Object {Add2Log "DELETED: $_"}
            Add2Log "RECLAIMED: $GotMSInstallersSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $MSInstallers
			$global:Reclaimed=$global:Reclaimed + $GotMSInstallersSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey package embedded Microsoft installers to delete." -Foreground Green
	}
}

# Deletes read me files from package installs
function DeleteReadmes {
	$GotReadmesSize=0
	$GotReadmes=Get-ChildItem -Path $ENV:ChocolateyInstall\* -Recurse -Include $readme_types -ErrorAction SilentlyContinue
	if ($error[0].categoryinfo.category -match "PermissionDenied") {
        $global:PermissionErrors=$True
		$ErrorPath=$error[0].categoryinfo.targetname
	    Add2LogError "reading $ErrorPath due to permissions."
	    }
	$Readmes=$GotReadmes.count
	if ($Readmes -ge 1){
		Write-Host "  ** Deleting $Readmes unnecessary Chocolatey package embedded various read me files..." -Foreground Green
	    $GotReadmes | ForEach-Object {$GotReadmesSize=$GotReadmesSize + $_.length}
		Remove-Item -Path $ENV:ChocolateyInstall\* -Recurse -Include $readme_types -ErrorAction SilentlyContinue
	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
    		$global:PermissionErrors=$True
	    	Add2LogError "deleting unnecessary Chocolatey package embedded various read me files due to permissions."
	    } else {
		    $GotReadmes.fullname | ForEach-Object {Add2Log "DELETED: $_"}
            Add2Log "RECLAIMED: $GotReadmesSize bytes"
			$global:DeletedFiles=$global:DeletedFiles + $Readmes
			$global:Reclaimed=$global:Reclaimed + $GotReadmesSize
		}
	} else {
		Write-Host "  ** NO unnecessary Chocolatey package embedded various read me files to delete." -Foreground Green
	}
}

# Deletes shims that point to programs that have been uninstalled
function DeleteBadShims {
    $BadShimCount=0
    $ShimsSizeBefore=0
    $ShimsSizeAfter=0
    Write-Host "  ** Checking shim files..." -NoNewline -Foreground Green
    $GotShims=(Get-ChildItem $ENV:ChocolateyInstall\bin\*.exe -ErrorAction SilentlyContinue)
    $GotShims | ForEach-Object {$ShimsSizeBefore=$ShimsSizeBefore + $_.length}
    $GotShims | ForEach-Object {
    	if (-not (Test-ShimTargetExists $PSItem -ErrorAction SilentlyContinue) ){
		    $BadShimCount = $BadShimCount +1
    		Remove-Item "$PSItem" | Out-Null -ErrorAction SilentlyContinue
    	    if ($error[0].categoryinfo.category -match "PermissionDenied") {
        		$global:PermissionErrors=$True
    	    	Add2LogError "deleting unnecessary Chocolatey orphaned shim files due to permissions."
    	    } else {
    		    Add2Log "DELETED: $PSItem"
    		}
	    }
    }
    Write-Host "`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b                            `b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b`b" -NoNewLine
    if ($BadShimCount){
    	Write-Host "  ** Deleted $BadShimCount unnecessary Chocolatey orphaned shim files..." -Foreground Green
    	$GotShims=(Get-ChildItem $ENV:ChocolateyInstall\bin\*.exe -ErrorAction SilentlyContinue)
        $GotShims | ForEach-Object {$ShimsSizeAfter=$ShimsSizeAfter + $_.length}
    	$ShimSizeDeleted=($ShimsSizeBefore - $ShimsSizeAfter)
        Add2Log "RECLAIMED: $ShimSizeDeleted bytes"
    	$global:DeletedFiles=$global:DeletedFiles + $BadShimCount
        $global:Reclaimed=$global:Reclaimed + ($ShimsSizeBefore - $ShimsSizeAfter)
    } else {
    	Write-Host "  ** NO unnecessary Chocolatey orphaned shim files to delete." -Foreground Green
    }
}

##### MAIN FUNCTIONS END
##### BEGIN PROCESSING

# Start logging
if (Test-Path "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"){
	$LogSize=(Get-ChildItem -Path "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log").length
	if ($LogSize -gt 51200){
		Remove-Item "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"  -ErrorAction SilentlyContinue
		if ($error[0].categoryinfo.category -match "PermissionDenied") {$global:PermissionErrors=$True}
		Write-Output "$(Get-Date) Choco-Cleaner Deleted log file" >> "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"
	}
}
Write-Output "----------------------------------------------------------------------" >> "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"
Write-Output "$(Get-Date) Choco-Cleaner STARTED" >> "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"
Write-Host "Choco-Cleaner Summary:" -Foreground Magenta

# Begin cleaning
DelProcessedTxt
Add2Log "CONFIG: DeleteIgnoreFiles is set to $DeleteIgnoreFiles"
if ($DeleteIgnoreFiles) {DeleteIgnoreFiles}
Add2Log "CONFIG: DeleteOldChoco is set to $DeleteOldChoco"
if ($DeleteOldChoco) {DeleteOldChoco}
Add2Log "CONFIG: DeleteCache is set to $DeleteCache"
if ($DeleteCache) {DeleteCache}
Add2Log "CONFIG: DeleteNuGetCache is set to $DeleteNuGetCache"
if ($DeleteNuGetCache) {DeleteNuGetCache}
Add2Log "CONFIG: DeleteConfigBackupFile is set to $DeleteConfigBackupFile"
if ($DeleteConfigBackupFile) {DeleteConfigBackupFile}
Add2Log "CONFIG: DeleteLibBad is set to $DeleteLibBad"
if ($DeleteLibBad) {DeleteLibBad}
Add2Log "CONFIG: DeleteLibBkp is set to $DeleteLibBkp"
if ($DeleteLibBkp) {DeleteLibBkp}
Add2Log "CONFIG: DeleteLibSynced is set to $DeleteLibSynced"
if ($DeleteLibSynced) {DeleteLibSynced}
Add2Log "CONFIG: DeleteDotChocolatey is set to $DeleteDotChocolatey"
if ($DeleteDotChocolatey) {DeleteDotChocolatey}
Add2Log "CONFIG: DeleteFileLogs is set to $DeleteFileLogs"
if ($DeleteFileLogs) {DeleteFileLogs}
Add2Log "CONFIG: DeleteLogs is set to $DeleteLogs"
if ($DeleteLogs) {DeleteLogs}
Add2Log "CONFIG: DeleteArchives is set to $DeleteArchives"
if ($DeleteArchives) {DeleteArchives}
Add2Log "CONFIG: Optimizenupkg is set to $Optimizenupkg"
if ($Optimizenupkg) {Optimizenupkg}
Add2Log "CONFIG: DeleteLicenseFiles is set to $DeleteLicenseFiles"
if ($DeleteLicenseFiles) {DeleteLicenseFiles}
Add2Log "CONFIG: DeleteMSInstallers is set to $DeleteMSInstallers"
if ($DeleteMSInstallers) {DeleteMSInstallers}
Add2Log "CONFIG: DeleteReadmes is set to $DeleteReadmes"
if ($DeleteReadmes) {DeleteReadmes}
Add2Log "CONFIG: DeleteBadShims is set to $DeleteBadShims"
if ($DeleteBadShims) {DeleteBadShims}

# Summary report
if ($global:PermissionErrors) {Write-Host "  ** Some files not deleted due to permission problems." -Foreground Yellow}
$global:Reclaimed=$global:Reclaimed/1KB
$global:Reclaimed = $global:Reclaimed.ToString('N0')
Write-Host "Choco-Cleaner finished deleting $global:DeletedFiles unnecessary Chocolatey files and reclaimed ~ $global:Reclaimed KB!`n" -Foreground Magenta
Write-Output "$(Get-Date) Choco-Cleaner FINISHED and reclaimed ~ $global:Reclaimed KB!" >> "$ENV:ChocolateyToolsLocation\BCURRAN3\choco-cleaner.log"
Write-Host "Found Choco-Cleaner.ps1 useful?" -ForegroundColor White
Write-Host "Buy me a beer at https://www.paypal.me/bcurran3donations" -ForegroundColor White
Write-Host "Become a patron at https://www.patreon.com/bcurran3" -ForegroundColor White
Start-Sleep -s 10
exit $global:CCExitCode
