<img src="https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/mylogos/myunofficialChocolateylogo_icon.png" width="139" height="88">

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original!
* I personally use and endorse this extension.

## **Chocolatey OS Dependency Extension is a Chocolatey extension for use as a dependency by package maintainers to validate OS compatibility.**

### PURPOSE:
To provide a Chocolatey extention with easy to remember functions for package creators/maintainers to verify an OS version requirement during package installation. The OS version is checked and if found not compatible, the package installation is aborted. The functions are named Confirm-WinX; where X can be 11, 10, 81, 8, or 7.

### USAGE:
If you package a program that has a minimum requirement of Windows 10, add Confirm-Win10 after your EAP statement in your chocolateyInstall.ps1 script. If the the Windows version is not 10 or 11, the package installation with abort.

### HELPERS:
* **Confirm-Win11** - Checks for Windows 11 and aborts package install if not.
* **Confirm-Win10** - Checks for Windows 10 (or 11) and aborts package install if not.
* **Confirm-Win81** - Checks for Windows 8.1 and aborts package install if not.
* **Confirm-Win80** - Checks for Windows 8.0 and aborts package install if not.
* **Confirm-Win8**  - Checks for Windows 8.0 or 8.1 and aborts package install if not.
* **Confirm-Win7**  - Checks for Windows 7 and aborts package install if not.

* NOTE: You can also specify a build number as a minimum requirement. EXAMPLE: Confirm-Win10 2004

### CHANGE LOG:
* 0.0.1 - initial release

### ROADMAP:
* Add Windows Server OS Checking
* I am open to any useful suggestions/additions! Please open a GitHub issue if so.

***

***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3)? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>