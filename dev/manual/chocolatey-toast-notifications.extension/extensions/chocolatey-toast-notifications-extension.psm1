# chocolatey-toast-notifications.extension v0.0.4 by Bill Curran AKA BCURRAN3 - 2018-2020 Copyleft Bill Curran

$scriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition

if (!(Test-Path "$ChocolateyInstall\extensions\chocolatey-toast-notifications\choco.ico")){
     [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')  | Out-Null
     [System.Drawing.Icon]::ExtractAssociatedIcon("$env:ChocolateyInstall\choco.exe").ToBitmap().Save("$env:ChocolateyInstall\extensions\chocolatey-toast-notifications\choco.ico")
}

$publicFunctions = @(
    'Get-ChocolateySoftwareName',
    'Install-ChocolateyInstallPackageWithToastNotification',
	'Uninstall-ChocolateyPackageWithToastNotification'
)

Get-ChildItem -Path "$scriptRoot\*.ps1" | ForEach-Object { . $_ }
Export-ModuleMember -Function $publicFunctions

Set-Alias Install-ChocolateyInstallPackage Install-ChocolateyInstallPackageWithToastNotification -Force -Scope Global
Set-Alias Uninstall-ChocolateyPackage Uninstall-ChocolateyPackageWithToastNotification -Force -Scope Global
