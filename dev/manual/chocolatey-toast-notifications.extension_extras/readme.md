<img src="https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/mylogos/myunofficialChocolateylogo_icon.png" width="139" height="88">

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original!
* I personally use and endorse this extension.

![Screenshot of Chocolatey Toast Notifications Extension](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/chocolatey-toast-notifications.extension_extras/chocolatey-toast-notifications.extension_screenshot.png)

### It's HERE! The 100% Chocolatey user OPT-IN toast notification extension for Chocolatey and Windows 10 (only).

## **Chocolatey Toast Notifications Extension** is a Chocolatey extension that displays a toast notification after installing or uninstalling a program. This extension will start working automatically once installed and does NOT need to be implemented by package creators/maintainers. **Chocolatey Toast Notifications Extension** is meant to be installed and used directly by Chocolatey end users.

### PURPOSE:

* Chocogeeky fun!

### FEATURES: 
* **Chocolatey Toast Notifications Extension** will display a toast notification with the package name, program name, program version, status message (installed or uninstalled), and a link to the package page on the chocolatey.org website after a program is installed or uninstalled.

### WHAT IT WON'T DO:
* **Chocolatey Toast Notifications Extension** will NOT work on anything other than Windows 10, this is a limitation of the [BurntToast](https://github.com/Windos/BurntToast) PowerShell module and its use of the [UWP Community Toolkit](https://github.com/Microsoft/WindowsCommunityToolkit). (Yes, I tried it on Windows Server 2016 and it did NOT work.)
* **Chocolatey Toast Notifications Extension** will NOT display messages for programs that don't use standard installers, i.e. portable programs.

**[PACKAGE NOTES](https://github.com/bcurran3/ChocolateyPackages/blob/master/chocolatey-toast-notifications.extension/readme.md)**

***
**Click here to [Patreon-ize](https://www.patreon.com/bcurran3) the package maintainer.**
***

### CHANGE LOG:
* 0.0.3.1 - bug fix for background tasks sending foreground notifications
* 0.0.3 - Notifications will now display in the foreground when sent from a background task using the system account.
* 0.0.2 - baked in compatibility with [chocolatey-preinstaller-checks.extension](https://chocolatey.org/packages/chocolatey-preinstaller-checks.extension) if installed
* 0.0.1 - initial release

### ROADMAP:
* Possibly make it Windows 8 compatible after packaging up an old version of [BurntToast](https://github.com/Windos/BurntToast)
* Possibly make it Windows Server 2016 compatible.
* Attempt to make it work with PORTABLE packages as well.

***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3 )? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>
