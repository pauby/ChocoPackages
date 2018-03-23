# ![Azure PowerShell Logo](https://cdn.rawgit.com/pauby/ChocoPackages/c5b46bdfe07ce816de0ffc3b1366aab4c4e5a240/icons/azurepowershell.png "Azure PowerShell Logo") [Azure PowerShell](https://chocolatey.org/packages/azurepowershell)

Azure PowerShell provides a set of cmdlets that use the Azure Resource Manager model for managing your Azure resources. You can use it in your browser with Azure Cloud Shell, or you can install it on your local machine and use it in any PowerShell session.

Azure PowerShell requires PowerShell 3.0 or later, which can be installed using the [powershell](https://chocolatey.org/packages/powershell) package. This package does not define a dependency on that package to avoid causing a potentially undesired update to the newest PowerShell.

This package modifies the Azure PowerShell installation process in order to stop the Azure PowerShell installer from:
- killing all powershell.exe and powershell_ise.exe processes (to prevent data loss),
- modifying the PowerShell execution policy (because the user should be in control of that).
