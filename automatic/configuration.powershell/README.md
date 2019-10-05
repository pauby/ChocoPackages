# ![configuration.powershell Logo]https://rawcdn.githack.com/pauby/ChocoPackages/07aa152888ca3c503858f4521b0881c446c2d186/icons/configuration.powershell.png "Configuration Logo") [configuration.powershell Chocolatey Package](https://chocolatey.org/packages/configuration.powershell)

A module for saving and loading settings and configuration objects for PowerShell modules (and scripts).

The Configuration module supports layered configurations with default values, and serializes objects and hashtables to the simple PowerShell metadata format with the ability to extend how your custom types are serialized, so your configuration files are just .psd1 files!

The key feature is that you don't have to worry about where to store files, and modules using the Configuration commands will be able to easily store data even when installed in write-protected folders like Program Files.

Supports WindowsPowerShell, as well as PowerShell Core on Windows, Linux and OS X.

You can pass the following parameters:

* `/core`     - Installs the module in the AllUsers scope for PowerShell Core;
* `/desktop`  - Installs the module in the AllUsers scope for Windows PowerShell (ie. Desktop Edition);

You can pass both `/core` and `/desktop` parameters to install on both. If you pass no parameters then `/desktop` is assumed.

**NOTE: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.**