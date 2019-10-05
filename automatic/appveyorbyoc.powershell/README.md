# ![appveyorbyoc.powershell Logo](https://rawcdn.githack.com/pauby/ChocoPackages/3a4faf76b6852e70458c92a21be40351f6de1834/icons/appveyorbyoc.powershell.png "AppVeyorByoc Logo") [appveyorbyoc.powershell Chocolatey Package](https://chocolatey.org/packages/appveyorbyoc.powershell)

AppVeyor Bring-Your-Own-Cloud/Computer (BYOC) - PowerShell module to enable hosted AppVeyor CI account or on-premise AppVeyor Server installation running builds on a custom build cloud (Azure, AWS, GCE, Hyper-V, Docker) or computer directly (Windows, Linux, Mac).

You can pass the following parameters:

* `/core`     - Installs the module in the AllUsers scope for PowerShell Core;
* `/desktop`  - Installs the module in the AllUsers scope for Windows PowerShell (ie. Desktop Edition);

You can pass both `/core` and `/desktop` parameters to install on both. If you pass no parameters then `/desktop` is assumed.

_**NOTE: This module required at least PowerShell v5.**_

**NOTE: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.**