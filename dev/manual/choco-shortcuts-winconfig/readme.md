<img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/myunofficialChocolateylogo_icon.png" width="139" height="88">

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original! So of course I endorse and use it. :)
* Yes, I considered icons for more advanced functions such as to view and change Chocolatey Features, Sources, Pinning, and apikey. BUT (notice that's a big but) those are advanced commands that I feel the average user wouldn't need. The people who know what those things do are more likely to just go to the Command Prompt and do it there. A bigger reason why I didn't add this is that Windows 10 doesn't allow nested menus. So if I added another 3-9 shortcuts, it would be very cluttered. On Windows 7 the additional shortcuts could be managed nicely under a separate folder, I wish Windows 10 worked that way still.. If anyone requests it, I'd be glad to make a choco-shortcuts-advanced-winconfig with the more advanced commands and set this package as a dependency.

![Screenshot of Choco Shortcuts](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/choco-shortcuts-winconfig/choco-shortcuts-winconfig_screenshot.png)	

# This package creates Windows Start Menu shortcuts to run common Chocolatey functions.

### WHO IS THIS FOR?
 **Chocolatey Shortcuts** is designed for those who aren't comfortable with the Command Prompt or just don't like to type much. **Chocolatey Shortcuts** allows you to perform the most common Chocolatey functions right from the Windows Start Menu. The shortcuts still shell out to the Command Prompt to run, but **Chocolatey Shortcuts** is designed to be incredibly simple to use with minimal typing; install or remove a program in a few clicks and type in the package name. **Chocolatey Shortcuts** is also useful to support professionals who know the difficulty of getting end users to type in commands correctly, now you can just point them to the Windows Start Menu!

### WHY DO I NEED THIS?
If you're a power user or use the Command Line and/or PowerShell all the time, you probably don't; though the website links might be useful for remembering where to find various Chocolatey resources.

### FEATURES:
* Search for, install, and uninstall a package from the Windows Start Menu.
* List installed and outdated packages from the Windows Start Menu.
* Upgrade all installed packages from the Windows Start Menu (will use [choco-upgrade-all.ps1](https://raw.githubusercontent.com/bcurran3/ChocolateyPackages/master/choco-upgrade-all-at/tools/choco-upgrade-all.ps1) if **[Choco Upgrade All at](https://community.chocolatey.org/packages/choco-upgrade-all-at)** or **[Choco Upgrade All at Startup](https://community.chocolatey.org/packages/choco-upgrade-all-at-startup)** are installed)
* Optimize your packages from the Windows Start Menu. ([Chocolatey licensed](https://chocolatey.org/pricing) users)
* Moves **[Choco Cleaner](https://community.chocolatey.org/packages/choco-cleaner)**, **[ChocolateyGUI](https://community.chocolatey.org/packages/chocolateygui)**, **[Choco Package List Backup](https://community.chocolatey.org/packages/choco-package-list-backup)**, and **[Chocolatey  PowerShell](https://community.chocolatey.org/packages/chocolateypowershell)** icons to the new Chocolatey Start Menu folder if they are installed.
* View chocolatey.log from the Windows Start Menu.
* Website links to prominent Chocolatey information.

For a different take on Chocolatey Shortcuts for the desktop, checkout [mica](https://community.chocolatey.org/profiles/mica)'s [Chocolatey Shortcuts (unofficial)](https://community.chocolatey.org/packages/ChocoShortcuts).

Also check out **[(unofficial) Install Chocolatey Packages from your Web Browser](https://community.chocolatey.org/packages/choco-install-packages-from-web-winconfig)** which is another package I made that makes Chocolatey easy (Chocolateasy!) for new users to digest.

### CHANGELOG:
* 0.0.3   - updated website links to current URLs, use new icons created by Teknowledgist for Choco-Cleaner and Chocolatey PowerShell, minor logic changes on creating icons for my scripts as well as run them via their "shims", move ChocolateyGUI icon to Chocolatey icons folder if it's installed, uses choco-upgrade-all.ps1 if choco-upgrade-all-at or choco-upgrade-all-at-startup are installed
* 0.0.2.2 - added FeedBurner RSS link
* 0.0.2.1 - bug fix, the "egg on face release"
* 0.0.2   - added link to Chocolatey status website, added support for moving my newer utils icons to the Chocolatey folder, minor organizational and optimization
* 0.0.1   - initial release

### ROADMAP:
* possibly add package builder if found
* I'm open to suggestions - open a GitHub issue please.

***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3)? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>

