# ![powershellbuild.powershell Logo](https://rawcdn.githack.com/pauby/ChocoPackages/09a4ba9b4dbfd187b39139f0d9f9b25965868279/icons/powershellbuild.powershell.png "PowerShellBuild Logo") [powershellbuild.powershell Chocolatey Package](https://chocolatey.org/packages/powershellbuild.powershell)

This project aims to provide common psake and Invoke-Build tasks for building, testing, and publishing PowerShell modules.

Using these shared tasks reduces the boilerplate scaffolding needed in most PowerShell module projects and help enforce a consistent module structure. This consistency ultimately helps the community in building high-quality PowerShell modules.

You can pass the following parameters:

* `/core`     - Installs the module in the AllUsers scope for PowerShell Core;
* `/desktop`  - Installs the module in the AllUsers scope for Windows PowerShell (ie. Desktop Edition);

You can pass both `/core` and `/desktop` parameters to install on both. If you pass no parameters then `/desktop` is assumed.

_**NOTE: This module required at least PowerShell v3.**_

**NOTE: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.**