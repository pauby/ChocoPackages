$ErrorActionPreference = 'Stop'
$packageName = 'choco-persistent-packages'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pp          = Get-PackageParameters
$TaskCommand = 'cinst $env:ChocolateyInstall\config\persistentpackages.config -y'
$CheckConfig = "$env:ChocolateyInstall\config\persistentpackages.config"

$GotTask = (&schtasks /query /tn choco-persistent-packages) 2> $null
if ($GotTask -ne $null){
   Write-Host Existing choco-persistent-packages scheduled task found. Keeping existing scheduled task and persistentpackages.config file. If you want to change the task runtime or abort time, uninstall and reinstall the package. Uninstalling the package will not delete your persistentpackages.config file. -foreground magenta -background blue
   exit
  }

if (Test-Path $CheckConfig){
    Remove-Item "$toolsDir\persistentpackages.config"
    } else {
      Move-Item "$toolsDir\persistentpackages.config" "$env:ChocolateyInstall\config" -Force -ErrorAction 'SilentlyContinue'
	  $WhoAmI=whoami
      $Acl = Get-Acl "$env:ChocolateyInstall\config\persistentpackages.config"
      $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($WhoAmI,"FullControl","Allow")
      $Acl.SetAccessRule($Ar)
      Set-Acl "$env:ChocolateyInstall\config\persistentpackages.config" $Acl
    }
	
Write-Host "" 
Write-Host "choco-persistent-packages Summary:" -foreground magenta	

if ($pp["Time"] -eq $null -or $pp["Time"] -eq ''){
     $RunTime = "00:00"
     Write-Host " * TIME NOT specified, defaulting to MIDNIGHT." -foreground magenta
    } else {
      $RunTime = $pp["Time"]
	  Write-Host " * TIME specified as $RunTime." -foreground magenta
	 }

if ($pp["ABORTTIME"] -eq $null -or $pp["ABORTTIME"] -eq ''){
      Write-Host " * ABORTTIME NOT specified, defaulting to 1 AM." -foreground magenta
	  $AbortTime = "01:00"
    } else {
	  $AbortTime = $pp["ABORTTIME"]
	  Write-Host " * ABORTTIME specified as $AbortTime." -foreground magenta
    } 	 

SchTasks /Create /SC DAILY /RU SYSTEM /RL HIGHEST /TN "choco-persistent-packages" /TR $TaskCommand /ST $RunTime /F
SchTasks /query /tn "choco-persistent-packages"
SchTasks /CREATE /SC DAILY /RU SYSTEM /RL HIGHEST /TN choco-persistent-packages-abort /TR "taskkill /im choco.exe /f /t" /ST $AbortTime /F
SchTasks /query /tn choco-persistent-packages-abort
Write-Host " * To configure, edit $env:ChocolateyInstall\config\persistentpackages.config and read the comments section." -foreground magenta
Start-Sleep -s 10

