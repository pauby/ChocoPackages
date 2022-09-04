# ![LanguageTool](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@8df3772/icons/languagetool.png "LanguageTool Logo") [LanguageTool](https://chocolatey.org/packages/languagetool)

LanguageTool is an Open Source proofreading software for English, French, German, Polish, Russian, and more than [20 other languages](https://languagetool.org/languages/). It finds many errors that a simple spell checker cannot detect.

## Notes

* **This software in this package _requires_ a Java Runtime Engine. It will not work without one.** As there are so many flavours of Java I leave it to you to choose the one your prefer. My current recommendation is [Temurin](https://community.chocolatey.org/packages/Temurinjre) if you don't already have one installed.
* The LanguageTool binaries are extracted to the `languagetool` folder of the local tools folder (by default `c:\tools` - see [`Get-ToolsLocation`](https://docs.chocolatey.org/en-us/create/functions/get-toolslocation) for more information). This provides a consistent location for the binaries and allows easier management when upgrading versions.
* **NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.
