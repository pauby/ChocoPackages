<img src="https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/mylogos/myunofficialChocolateylogo_icon.png" width="139" height="88">

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original!
* I personally use and endorse this extension.

![Screenshot of chocolatey-preinstaller-checks.extension](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/chocolatey-preinstaller-checks.extension_extras/chocolatey-preinstaller-checks.extension_screenshot.png)

## **Chocolatey Preinstaller Checks Extension** is a Chocolatey extension that intercepts and runs checks before installing or uninstalling a program. This extension will start working automatically once installed and does NOT need to be implemented by package creators/maintainers. **Chocolatey Preinstaller Checks Extension** is meant to be installed and used directly by Chocolatey end users.

### PURPOSE:

This extension attempts to head off problems related to:

* [https://github.com/chocolatey/choco/issues/544](https://github.com/chocolatey/choco/issues/544)
* [https://github.com/chocolatey/choco/issues/619](https://github.com/chocolatey/choco/issues/619)
* [https://github.com/chocolatey/choco/issues/761](https://github.com/chocolatey/choco/issues/761)
* [https://github.com/chocolatey/choco/issues/780](https://github.com/chocolatey/choco/issues/780)
* [https://github.com/chocolatey/choco/issues/1526](https://github.com/chocolatey/choco/issues/1526)
* [https://github.com/chocolatey/choco/issues/1548](https://github.com/chocolatey/choco/issues/1548)
* [https://github.com/chocolatey/choco/issues/1579](https://github.com/chocolatey/choco/issues/1579)
* and possibly others until such time that Chocolatey natively handles these issues better and this extension becomes moot. (Rumored to be 1.0.0 milestone)

**Chocolatey Preinstaller Checks Extension**'s main purpose is to fend off specific types of problems before they occur. Currently Chocolatey (choco.exe) is not multi-instance friendly. If you try to install or uninstall packages using choco.exe in two Command Prompts at the same time, strange (bad!) things may occur. **Chocolatey Preinstaller Checks Extension** can avoid these strange (bad!) things by intercepting calls to install and uninstall programs and warn about the situation, wait for previous instances to finish, or abort; totally configurable. **Chocolatey Preinstaller Checks Extension** also checks Windows Installer to see if it's busy and will warn, make MSI installer and uninstaller programs wait until Windows Installer has finished processing the other program, or abort. **Chocolatey Preinstaller Checks Extension** only runs before PROGRAM installations and uninstallations. It does not perform any functions related to portable packages or other choco commands.

### FEATURES: 
* **Chocolatey Preinstaller Checks Extension** is completely configurable to warn, wait, or abort.
* **Chocolatey Preinstaller Checks Extension** will check if there is a pending reboot and warn you about it if so.
* **Chocolatey Preinstaller Checks Extension** will check if Windows Installer is already running and warn, wait for it to finish, or abort.
* **Chocolatey Preinstaller Checks Extension** will check if there are instances of choco.exe already running and warn, wait for it to finish, or abort.

### CHANGE LOG:
* 0.0.2.3 Removed Chocolatey dependency as Chocoaltey v1.0 has been released and missed the 1.x milestone of becoming multi-instance aware and no new known goal.
* 0.0.2.1 Added dependencies to package, no updates to actual extension.
* 0.0.2 - Added conditional handling options for each of the three checks, completely configurable (See C:\ProgramData\chocolatey\extensions\chocolatey-preinstaller-checks\Chocolatey-Preinstaller-Checks.xml). Now compatible with [Chocolatey Toast Notifications Extension](https://chocolatey.org/packages/chocolatey-toast-notifications.extension). Get-chocoCounts replaced by Get-chocoInstanceCounts (Thanks by Michel Buczynski AKA MikeBoutch!) for Chocolatey Self Service Agent compatibility. Default 30 second pause changed to 5 seconds and cosmetically better display.
* 0.0.1 - initial release

ROADMAP:
* Option to abort install/uninstall if PendingRebootStatus is true.
* Option to abort after a configurable amount of time waiting for other competing processes to finish.

***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3)? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>



