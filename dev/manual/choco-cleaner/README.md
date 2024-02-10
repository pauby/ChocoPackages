<img src="https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/choco-cleaner/choco-cleaner_icon.png" width="200" height="200">

![Screenshot of Choco-Cleaner](https://raw.githubusercontent.com/bcurran3/ChocolateyPackages/master/choco-cleaner/choco-cleaner_screenshot.png)	

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original! So of course I endorse and use it. :)
* If you don't like the default scheduled time to run, you can easily change it using Window's TaskScheduler.
* I'm open to suggestions - open a GitHub issue please.

## DO YOU WANT TO RECOVER SOME DISK SPACE USED BY UNNECESSARY RESIDUAL CHOCOLATEY FILES? 

## YOU JUST FOUND THE EASY WAY!

#### This package creates a Windows Scheduled Task to run Choco-Cleaner.ps1 every Sunday at 11:00 PM.

## **BEFORE and AFTER Choco-Cleaner: (198 packages installed and does not include temp folder deletions.)**
![schreenshot of files and diskspace  before Choco-Cleaner](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/choco-cleaner/choco-cleaner_before.png) ![schreenshot of files and diskspace after choco-cleaner](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/choco-cleaner/choco-cleaner_after.png)

**Sure, you're probably not going to get gigabytes of space back, but every few KB matters on some computers and to some people! Due to [slack space](https://www.computerhope.com/jargon/s/slack-space.htm) small files such as 6 byte .ignore files actually take up 4 KB of HDD space each.**

## FEATURES:

Set it and forget it! **Choco-Cleaner** cleans up your Chocolatey installation every Sunday at 11 PM in the background so you don't have to be bothered with it.

**Choco-Cleaner** is completely configurable, just run **Choco-Cleaner -EditConfig** and read the comments. Most options are enabled by default.
	
**Choco-Cleaner deletes:**

* .log files that are not the most current one (NOT default)
* .zip and various archive files left over from packages that forgot to delete them post install
* .zip.txt and other archive-extensions.txt are lists of files that were extracted from an archive file for installation (NOT default)
* .msi, .msu, and .msp are Microsoft intall packages left over from packages that forgot to delete them post install
* .ignore files that are created to not shim executables during package install but not needed after shim operations are finished (This may change in a future version of Chocolatey.)
* credits.txt are program credits (of contributors) files you can read on the web
* readme.txt files you can read on the web
* .md files are usually markdown readme files that you can read on the web
* .old files are Chocolatey files that have been replaced by newer versions (exe's and dll's mostly)
* chocolatey.config.backup is a backup of your chocolatey.config file
* _processed.txt - I have no idea what made this file or why it exists
* lib-bad holds packages that failed to install and lib-bkp contains previous package versions during upgrades
* lib-synced holds packages installed by the (licensed versions) choco sync feature (NOT default)
* archives and executables out of .nupkg files which are ZIP archives with NuGet package information - this is similar to what [Package Reducer](https://chocolatey.org/docs/features-package-reducer) does
* \users\username\AppData\Local\Temp\chocolatey is where new package files are downloaded to during pre-installation (if you haven't changed your cacheLocation in chocolatey.config)
* files in cacheLocation if set in chocolatey.config
* \users\username\AppData\Local\Nuget\Cache if Nuget client is installed and caching files there
* \Windows\Temp\chocolatey 
* license.txt and verification.txt files are included when packages include binaries, you can read them on the package web page, programname.license.txt files are license files for Chocolatey default tools (NOT default)
* orphaned shim files for programs that no longer exist
* orphaned package install snapshot files found in the .chocolatey folder

### INSTALL EXAMPLES:
* **choco install choco-cleaner** - (default) installs **Choco-Cleaner** to run every Sunday at 11:00 PM
* **choco install choco-cleaner --params "'/NOTASK:TRUE'"** - installs **Choco-Cleaner** without the scheduled task.

### INSTRUCTIONS:

To manually run **Choco-Cleaner**:

* Command Prompt or PowerShell: choco-cleaner
* Windows Start Menu: click the icon. If you have **[choco-shortcuts-winconfig](https://community.chocolatey.org/packages/choco-shortcuts-winconfig)** installed you'll find it with the rest of the Chocolatey Shortcuts.

If you have a previous release of **Choco-Cleaner** installed, upgrading to a new version will NOT modify your current preferences.

11:00 PM was chosen as not to conflict with default installs of **[choco-upgrade-all-at](https://chocolatey.org/packages/choco-upgrade-all-at)**,  **[choco-persistent-packages](https://chocolatey.org/packages/choco-persistent-packages)**, and **[choco-optimize-at](https://chocolatey.org/packages/choco-optimize-at)**.

**Organizations with software license compliance auditing should probably NOT delete the license and verification files for legal protection. The supplied configuration file defaults to false for these types of files. As ferventcoder/Rob has said many times, corporations are not advised to use the community repository and should be using [Chocolatey for Business](https://chocolatey.org/pricing) with their own internalized local packages.**

CHANGELOG:
* 1.1.1 - DeleteDotChocolatey now compatible with Chocolatey alpha/beta/delta/epsilon/zeta/eta/theta/iota/kappa/lambda/mu/nu/xi/omicron/pi/rho/sigma/tau/upsilon/phi/chi/psi/omega versions. No longer changes directory to .chocolatey when using DeleteDotChocolatey.
* 1.1.0 - Chocolatey v2 compatible - due to the breaking change to the choco list command in Chocolatey v2, all files in .chocolatey get deleted when DeleteDotChocolatey feature is enabled. CC now checks the Chocolatey version and uses the appropriate choco list command depending on version.
* 1.0.0 - v1.0 full feature release, all goals achieved! (The crowd roars... or is that just the sound of loud crickets?) You wanted **Choco-Cleaner** to delete the unnecessary files in the .chocolatey dir - you got it! now can delete files in lib-synced (opt-in), legend in config file got a much needed re-write (You won't see it/get it on upgrades.), no longer deletes .ignore files in Chocolatey program dirs as choco.exe regenerates 11 .ignore files EVERY time it runs now, changed log size from 4K to 50K due to increase in logging, "features" are now PS functions, now returns an exit code of 1 when there are errors
* 0.0.9.0 - now recursively deletes chocolatey and Nuget cache files from all user profiles, added more error reporting, changed log size from 1K to 4K, added -ViewLog option
* 0.0.8.5 - variable, spacing, and syntax cleanup by slycordinator, variables moved to top by Linux User
* 0.0.8.4 - Fix exception when $FreedSpace is less than zero thanks to kborowinski - Thanks!
* 0.0.8.3 - Fixed the reclaimed space calculation display thanks to salsifis - Thanks!
* 0.0.8.2 - "Psycological Phix" - I hate seeing a negative number "reclaimed" after running Choco-Cleaner due to other programs writing to disk while CC is running; e.g. downloads. So until such time as I accurately track the space of deleted files... if the result is negative, it'll now display zero. Like I said, only a psychological fix.
* 0.0.8.1 - Fixed v0.0.6 - v0.0.8 bug using unavailable environmental variable for scheduled task execution. Added small amount of logging.
* 0.0.8 - Added checking and deleting of orphaned shim files thanks to TheCakeIsNaOH and Teknowledgist! New icon thanks to Teknowledgist. Added parameter to install without scheduled task. Added -EditConfig option to easily edit the config file.
* 0.0.7.2 - Better error handling when $env:ChocolateyToolsLocation is not defined. (Usually due to running under a different account than installed from.)
* 0.0.7.1 - Added checking to make sure that $env:ChocolateyToolsLocation exists. If you receive a "$env:ChocolateyToolsLocation not defined error message," you might simply need to close your CLI and reopen it if $env:ChocolateyToolsLocation was created during choco-cleaner's install.
* 0.0.7 - Added some info about what and what isn't being deleted, added #Requires -RunAsAdministrator statement to script (PS v4+)
* 0.0.6 - Fixed long standing bug where the config options set to false were ignored. **Now works from Command Prompt as well as PowerShell.** Additional 7Zip supported archives deleted.
* 0.0.5.2 - minor update to delete .img (alternate .iso name), and .msi,.msu, and .msp files in toolsDir, as well as minor cosmetic changes
* 0.0.5.1 - made PowerShell Core compatible
* 0.0.5 - added deletion of cacheLocation if defined in chocolatey.config, cosmetic changes, removed 7Zip dependency and now using the version of 7Zip packaged with Chocolatey.
* 0.0.4 - added deletion of Nuget Cache folder files
* 0.0.3.1 - fixed typo causing nupkg files to NOT be optimized - thanks E.R.! 
* 0.0.3 - Rewritten version of 0.0.1 with XML configuration file and ferventcoder/Rob's approved default settings. Minor improvements.
* 0.0.2 - Unreleased version with two scripts with different default settings; "Bill's way" and "Rob's way" and a package parameter to choose which one to use/install. Shelved.
* 0.0.1 - Initial release. Did not pass Chocolatey moderation due to mandated changes of default parameters. Only "secretly" available.

### ROADMAP:
* Clean up C:\ProgramData\chocolatey\.chocolatey
* Clean up C:\ProgramData\chocolatey\lib-synced (licensed versions)

***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3)? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>
