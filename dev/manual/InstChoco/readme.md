<img src="https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/InstChoco/InstChoco_icon.png" width="139" height="88">

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original! So of course I endorse and use it. :)
* It is not recommended to run InstChoco without the -ynp switch on servers if you are using the Windows Active Directory Domain features!

![Screenshot of InstChoco in use](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/InstChoco/InstChoco_screenshot.png)

#InstChoco - The ULTIMATE Chocolatey and Chocolatey packages (re)installer!
	
##QUESTION: "Why do I need an installer for Chocolatey when I already have Chocolatey installed?"

##ANSWER: You need InstChoco for the NEXT time you want to install Chocolatey and automate package (re)installation!

**InstChoco** is the evolution of an old batch file I used over the years to automate installing Chocolatey followed by a bunch of "choco install program -y" commands to install my standard set of packages. I eventually decided to make it a program with additional features. I also integrated with other Chocolatey packages I've created. What you see now is the culmination of many long hard hours of work. I think **InstChoco** is the best it can be, but I'm always open to new features. Feel free to contact me with feedback. You can find **InstChoco.exe** in \ProgramData\chocolatey\lib\instchoco\tools. If you don't already have Chocolatey installed you can download **InstChoco** from [SOFTPEDIA](http://www.softpedia.com/get/System/System-Miscellaneous/InstChoco.shtml), [CNET's Download.com](https://download.cnet.com/InstChoco/3000-2094_4-77751542.html), or [directly from my GitHub repo](https://github.com/bcurran3/ChocolateyPackages/raw/master/InstChoco/tools/InstChoco.exe).

###FEATURES:

![Screenshot of InstChoco features](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/InstChoco/InstChoco_features_screenshot.png)

###Usage: 

![Screenshot of InstChoco Options](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/InstChoco/InstChoco_usage_screenshot.png)


ROADMAP:
* Possibly add domain security group specific package support; i.e. MARKETING needs GIMP but DEVELOPMENT doesn't. DEVELOPMENT needs NOTEPAD++ but SALES doesn't.
* Possibly add server specific support; i.e. Servers don't need all the packages that your workstations get from the packages in your domain package list. So maybe a DOMAINNAMEserverspackage.config would override if run on a server. Thinking...
* Add ability to use a different source other than the Chocolatey public repository. CANCELLED - sources can be listed inside packages.config.
* I'm open to suggestions - open a GitHub issue please.

###CHANGELOG:
* 2.10 - Added offline Chocolatey install option.
* 2.02 - Removed legacy date checking and connectivity checking which only worked in English environments.
* 2.01 - Fixed bug with non-domain joined computers.
* 2.00 - Added -browse, -popular, -backup, -backupwithversions, -license options as well as many cosmetic changes. Added iCloudDrive support. Commercial use of InstChoco v2+ requires a paid license.
* 1.30 - Added ability to download a packages.config file from the web and install packages from it.
* 1.21 - Added Box, Nextcloud, and Seafile support to catch up with choco-package-list-backup.
* 1.20 - Added domain support to install predefined packages for domain joined computers and user specific packages.
* 1.11 - (unreleased) Added -ynp switch to skip installation of packages. (Install Chocolatey only)
* 1.10 - Added [Choco Package List Backup to Local and Cloud](https://chocolatey.org/packages/choco-package-list-backup) and [Choco Persistent Packages](https://chocolatey.org/packages/choco-persistent-packages) support for package (re)installation. Cosmetic changes. Checks for year 2018 or greater instead of 2017 or greater. Updated donation info. :)
* 1.00 - Initial release.


***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3)? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>