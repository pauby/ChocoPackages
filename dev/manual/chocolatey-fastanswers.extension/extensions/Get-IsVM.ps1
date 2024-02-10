$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsVM{
$HyperV=Get-IsHyperV
$KVM=Get-IsKVM
$VirtualBox=Get-IsVirtualBox
$VMware=Get-IsVMware
$Xen=Get-IsXen
if ($HyperV -or $KVM -or $VirtualBox -or $VMware -or $Xen) {return $true} else {return $false}
}
