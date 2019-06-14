# ![PSScriptAnalyzer Logo](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@95cb2d6e/icons/psscriptanalyzer.png "PSScriptAnalyzer")[PSScriptAnalyzer](https://chocolatey.org/packages/psscriptanalyzer)

PSScriptAnalyzer is a static code checker for Windows PowerShell modules and scripts. PSScriptAnalyzer checks the quality of Windows PowerShell code by running a set of rules. The rules are based on PowerShell best practices identified by PowerShell Team and the community. It generates DiagnosticResults (errors and warnings) to inform users about potential code defects and suggests possible solutions for improvements.

PSScriptAnalyzer is shipped with a collection of built-in rules that checks various aspects of PowerShell code such as presence of uninitialized variables, usage of PSCredential Type, usage of Invoke-Expression etc. Additional functionalities such as exclude/include specific rules are also supported.

You can pass the following parameters:

* `/core`     - Installs the module in the AllUsers scope for PowerShell Core;
* `/desktop`  - Installs the module in the AllUsers scope for Windows PowerShell (ie. Desktop Edition);


**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.