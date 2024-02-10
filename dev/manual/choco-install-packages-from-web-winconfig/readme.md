<img src="https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/mylogos/myunofficialChocolateylogo_icon.png" width="139" height="88">

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original! So of course I endorse and use it. :)
* This package installs no software. The package creates/modifies Windows registry keys to set the default opening of .nupkg files to use Chocolatey's cinst.exe program. The package also creates Windows registry keys to always run cinst.exe with administrative priveledges. This new behavior will work in CLI and Windows GUI programs.
* Packages installed from browsers will request UAC permission, open a Command Prompt window, install the package, and then close the Command Prompt window. The same behavior will also happen when a .nuspec file is opened in a Windows GUI program or run from a CLI without administrative privileges. When cinst.exe is run from the Command Prompt with administrative privileges, it will act the same as before installation of this package; i.e. no UAC prompt necessary.
* This package has been tested and passed with Chrome, Firefox, and Opera. Edge is a bit trickier as Edge doesn't save the downloaded package file to the Downloads directory before choosing "Open" (file seemes to be temporarily sandboxed). If you save the .nuspec file and then open it, it should work fine.
* WARNING: Only install one package at a time until such time as Chocolatey v1.x is released. [(REFERENCE)](https://github.com/chocolatey/choco/issues/1579)
* DISCLAIMER: This has NOT been tested with non-Chocolatey .nupkg files.

ROADMAP:
* Possibly set each popular browsers to automatically run .nupkg files. (It's a lot of work to modify their config settings!)

***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3)? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>