# ![Adobe Acrobat Reader DC](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@fb3fc3a/icons/adobereader.png "Adobe Acrobat Reader DC Logo") [Adobe Acrobat Reader DC](https://chocolatey.org/packages/adobereader)

Adobe Acrobat Reader DC software is the free, trusted global standard for viewing, printing, signing, sharing, and annotating PDFs. It's the only PDF viewer that can open and interact with all types of PDF content – including forms and multimedia. And now, it’s connected to Adobe Document Cloud – so you can work with PDFs on computers and mobile devices.

This package installs/upgrades the Multi-lingual ("MUI") release. In some cases, this package will by default be able to install over the top of a language-specific installation. Otherwise, this package will exit and require either a manual uninstall of the language specific installation or having the parameter '/OverwriteInstallation' set to do this automatically.

## Package installation defaults

By default, this package:

- Will _NOT_ install a desktop icon.
- Will _NOT_ install the Adobe Reader and Acrobat Manager ("ARM") service. It the service already exists, it will _NOT_ remove it (it will disable it unless enabled by parameters).
- Will _NOT_ uninstall language-specific installations.
- Will configure Reader to only **check for updates manually** with confirmation for install.

## Package Parameters

- `/DesktopIcon` - The Desktop icon will be installed to the common desktop. (Install only.)
- `/NoUpdates` - No updates via internal mechanisms (including manual checks). Only downloading from Adobe and running installers or updates (or updating this package) will advance the version of Reader. Once set, only uninstalling this package will remove this update block.
- `/OverwriteInstallation` - Uninstall a language-specific installation before installing the Multi-lingual ("MUI") release. _Be aware that this will remove all data and features of an existing installation!_
- `/EnableUpdateService` - Install the AdobeARM service. (Does not override `/NoUpdates`.)
- `/UpdateMode:#` - Sets the update mode (below). (Does not override `/NoUpdates`.)
- `/IgnoreInstalled="SOFTWARE NAME"` - This parameter allows you to ignore software whose name matches a comma delimited list of wildcard strings. This is useful if you have other versions of Adobe Acrobat installed (such as [Adobe Acrobat X Pro](https://github.com/pauby/ChocoPackages/issues/197)). For example: `choco install adobereader --params="'/IgnoreInstalled="Adobe X*,Adobe Acrobat Y*"'"` will ignore any installation whose name matches `Adobe X*` or `Adobe Acrobat Y*`. **WARNING**: Only use this parameter if you know what you are doing. If you have an existing installation of Adobe Acrobat Reader and you exclude it from the list using this parameter, then the package will perform an installation believing the software is not installed which _will cause issues_. **You have been warned**.

### Update Modes

- `0` - Manually check for and install updates. (Default and reset on every update).
- `1` - Same as `0`.
- `2` - Download updates for me, but let me choose when to install them. (Appears to be no different than `0`).
- `3` - Install updates automatically (via task scheduler or ARM service if enabled).
- `4` - Notify me, but let me choose when to download and install updates.

These parameters can be passed to the installer with the use of `--params`.

For example :
`choco install adobereader --params '"/DesktopIcon /UpdateMode:4"'`

## Notes

- This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s), to let the know the package is no longer updating, using:
    - The 'Contact Maintainers' link on the package page, or
    - The 'Package Source' link on the package page and raising an issue.
