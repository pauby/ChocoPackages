# ![Adobe Acrobat Reader DC](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@fb3fc3a/icons/adobereader.png "Adobe Acrobat Reader DC Logo") [Adobe Acrobat Reader DC](https://chocolatey.org/packages/adobereader)

Adobe Acrobat Reader DC software is the free, trusted global standard for viewing, printing, signing, sharing, and annotating PDFs. It's the only PDF viewer that can open and interact with all types of PDF content – including forms and multimedia. And now, it’s connected to Adobe Document Cloud – so you can work with PDFs on computers and mobile devices.

This package installs/upgrades the Multi-lingual ("MUI") release. In some cases, this package will by default be able to install over the top of a language-specific installation. Otherwise, this package will exit and require either a manual uninstall of the language specific installation or having the parameter '/OverwriteInstallation' set to do this automatically.

## Note

If the package fails on Windows 8.1 or earlier, this might be due to the installation of kb2919355 (which is a dependency of this package) if your system is not up-to-date. This KB requires a reboot of the system before the adobereader package installs successfully.

## Package installation defaults

By default, **installation** of this package:

- Will _NOT_ install a desktop icon.
- Will _NOT_ install the Adobe Reader and Acrobat Manager ("ARM") service.
- Will _NOT_ uninstall language-specific installations.
- Will configure Reader to only **check for updates manually** with confirmation for install.

However, **upgrades** to Adobe Reader via this package:

- Will _NOT_ remove an existing desktop icon or add one when there isn't.
- Will _NOT_ install the AdobeARM service.
- Will _NOT_ remove the AdobeARM service (though it will disable it unless enabled by parameters).
- Will _NOT_ re-enable updates (if disabled via package parameter)

## Package Parameters

- `/DesktopIcon` - The Desktop icon will be installed to the common desktop. (Install only.)
- `/NoUpdates` - No updates via internal mechanisms (including manual checks). Only downloading from Adobe and running installers or updates (or updating this package) will advance the version of Reader. Once set, only uninstalling this package will remove this update block.
- `/OverwriteInstallation` - Uninstall a language-specific installation before installing the Multi-lingual ("MUI") release. _Be aware that this will remove all data and features of an existing installation!_
- `/EnableUpdateService` - Install the AdobeARM service. (Does not override `/NoUpdates`.)
- `/UpdateMode:#` - Sets the update mode (below). (Does not override `/NoUpdates`.)

### Update Modes

- `0` - Manually check for and install updates. (Default and reset on every update). Requires PowerShell 3+.
- `1` - Same as `0`. Requires PowerShell 3+.
- `2` - Download updates for me, but let me choose when to install them. (Appears to be no different than `0`).
- `3` - Install updates automatically (via task scheduler or ARM service if enabled).
- `4` - Notify me, but let me choose when to download and install updates.

These parameters can be passed to the installer with the use of `-params`.

For example :
`choco install adobereader -params '"/DesktopIcon /UpdateMode:4"'`
