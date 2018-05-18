# # ![Get-ChildItemColor Logo](https://cdn.rawgit.com/pauby/ChocoPackages/27a84273/icons/getchilditemcolor.png "Get-ChildItemColor")[Get-ChildItemColor](https://chocolatey.org/packages/getchilditemcolor)

Get-ChildItemColor provides colored version of Get-ChildItem Cmdlet and Get-ChildItem | Format-Wide (ls equivalent).

* This adds colors to the output of Get-ChildItem Cmdlet of PowerShell. It is based on Tim Johnson’s script and another script by the PowerShell Guy.
* Before version 1.0.0, the script actually had used Write-Host to write colored items on console. Now it just changes $Host.UI.RawUI.ForegroundColor and keep the item object intact. Hence, now one can use pipeline. (e.g., ~Get-ChildItemColor | grep “.git”~).
* Get-ChildItemColorFormatWide still uses Write-Host for output however. This is because Get-ChildItemColor | Format-Wide does not allow multiple colors in one line. Hence, pipeline does not work with Get-ChildItemColorFormatWide.

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.