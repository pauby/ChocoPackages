# ![WinGet-CLI](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@cd7c485/icons/winget-cli.png "WinGet-CLI Logo") [WinGet-CLI](https://chocolatey.org/packages/winget-cli)

The winget command line tool enables users to discover, install, upgrade, remove and configure applications on Windows 10 and Windows 11 computers. This tool is the client interface to the Windows Package Manager service.

## Notes:

- WinGet-CLI requires at least Windows 10 version 1809 (build 17763). See https://github.com/microsoft/winget-cli#installing-the-client for more information.
- WinGet-CLI requires 'Microsoft.UI.Xaml.2.7' Appx package and does not work if a later (2.8+) version _only_ is installed. The Chocolatey package takes care of this by adding the [`microsoft-ui-xaml-2-7`](https://community.chocolatey.org/packages/microsoft-ui-xaml-2-7) as a dependency.
- This is an automatically updated package. If you find it out of date by more than a week, please let the maintainer know using the 'Contact Maintainers' link on the package page.
