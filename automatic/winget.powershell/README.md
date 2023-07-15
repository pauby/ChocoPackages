# ![WinGet PowerShell Module](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@cd7c485/icons/winget-cli.png "PowerShell Logo") [winget.powershell](https://chocolatey.org/packages/winget.powershell)

This is the PowerShell module for the WinGet command line tool, 'Microsoft.WinGet.Client'.

You can pass the following parameters:

* `/core`     - Installs the module in the AllUsers scope for PowerShell Core;
* `/desktop`  - Installs the module in the AllUsers scope for Windows PowerShell (ie. Desktop Edition);

You can pass both `/core` and `/desktop` parameters to install on both. If you pass no parameters then `/desktop` is assumed.

## Notes

* This module requires at least PowerShell v5.1.0.
* This module requires WinGet CLI to be installed. We don't add this as a dependency as you may have this already installed outside of the Chocolatey ecosystem. However, to install it using Chocolatey CLI, run `choco install winget`.
* This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.
