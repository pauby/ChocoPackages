# chocolatey-fastanswers.extension v0.0.2.1 by Bill Curran AKA BCURRAN3 - public domain

$scriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition
 
$publicFunctions = @(
    'Get-Is32',
    'Get-Is64',
	'Get-IsAMDCPU'
    'Get-IsAMDVideo',
	'Get-IsARMCPU',
	'Get-IsHyperV',
    'Get-IsInDomain',
	'Get-IsIntelCPU',
    'Get-IsIntelVideo',
	'Get-IsKVM',
	'Get-IsMobile',
    'Get-IsNvidiaVideo',
    'Get-IsSSD',
    'Get-IsVirtualBox',
    'Get-IsVM',
    'Get-IsVMware',
    'Get-IsWin7',
    'Get-IsWin8',
    'Get-IsWin80',
    'Get-IsWin81',
    'Get-IsWin10',
    'Get-IsWin11',
    'Get-IsWinEdu',
    'Get-IsWinEnt',
    'Get-IsWinHome',
    'Get-IsWinPro',
    'Get-IsWinServer',
	'Get-IsWinServer2008',
	'Get-IsWinServer2008R2',
	'Get-IsWinServer2012',
	'Get-IsWinServer2012R2',
	'Get-IsWinServer2016',
	'Get-IsWinServer2019',
	'Get-IsWinServer2022',
	'Get-IsWinServerDatacenter',
	'Get-IsWinServerEssentials',
	'Get-IsWinServerFoundation',
	'Get-IsWinServerSBS',
	'Get-IsWinServerStandard',
	'Get-IsWinServerStorage',
	'Get-IsWinServerWeb',
	'Get-IsWinWorkstation',
	'Get-IsXen',
	'Get-NuspecInfo',
    'Get-PendingReboot',
    'Get-WinName',
    'Get-WinVerBuild',
    'Get-WinVerMajor',
    'Get-WinVerMinor'
)
 
Get-ChildItem -Path "$scriptRoot\*.ps1" | ForEach-Object { . $_ }
Export-ModuleMember -Function $publicFunctions