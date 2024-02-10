<img src="https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/mylogos/myunofficialChocolateylogo_icon.png" width="139" height="88">

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original!
* Read the INSTALL EXAMPLES again before use!
* I personally use and endorse this script/package/task.

#**choco-persistent-packages** (re)installs any missing crucial Chocolatey packages that you designate as persistant packages. Uninstall a persistent package and it will be installed again ready for use the next day. 

###This package creates a Windows Scheduled Task to run "cinst $env:ChocolateyInstall\config\persistentpackages.config -y" every day at a time that you specify. And because sometimes package installations go wrong... it will also create a Windows Scheduled Task to run "taskkill /im choco.exe /f /t" to stop the Chocolatey (choco.exe) process and all child processes at a time you specify.

###WHO IS THIS FOR?
 **choco-persistent-packages** is designed for [Chocolatey Pro](https://chocolatey.org/pricing) and [Chocolatey Business](https://chocolatey.org/pricing) licensed users who's computers are not necessarily under [Active Directory Directory Services Group Policy](https://technet.microsoft.com/en-us/library/hh147307(v=ws.10).aspx) control or other system mananagement utilities that can enforce software installation and desired state.

###WHY DO I NEED THIS?
If you have users/employees/a friend/a little brother/etc. that uninstalls programs/Chocolatey packages that you don't want uninstalled, **choco-persistent-packages** will (re)install those programs/Chocolatey packages that you deem necessary to keep installed. Basically you create a list of important packages and **choco-persistent-packages** will reinstall them every day if they are missing.

###WHY DO I NEED TO BE A CHOCOLATEY PRO OR BUSINESS USER?

You don't. But **choco-persistent-packages** will only work if the Chocolatey package data is missing. If a program is uninstalled outside of Chocolatey via Programs and Features this will not have any effect as Chocolatey and **choco-persistent-packages** will not know the program has been uninstalled. Chocolatey Pro and Business editions include a feature called [Package Synchronizer - Automatic Sync](https://chocolatey.org/docs/features-synchronize) which removes the Chocolatey package data when a program is uninstalled via Programs and Features. After this synchronization occurs (every execution of choco.exe), **choco-persistent-packages** will see the program/package missing and reinstall it at the designated time.
	
###INSTALL INSTRUCTIONS:
You can install **choco-persistent-packages** with TIME and ABORTTIME parameters to make it run daily at your preferred time. If you enter no parameters at all, **choco-persistent-packages** will default to run at midnight every day and abort the process at 1 AM. When entering the TIME and ABORTTIME parameters, use "[Military Time](http://militarytimechart.com/)." Not entering the correct format will fail the install. Please see the examples below.

###INSTALL EXAMPLES:
* **choco install choco-persistent-packages --params "'/TIME:04:00'"** - (re)installs persistent packages at 4 AM and aborts at 1 AM 21 hours later.
* **choco install choco-persistent-packages --params "'/TIME:06:30 /ABORTTIME:08:30'"** - (re)installs persistent packages at 6:30 AM and aborts at 8:30 AM.

####A NOTE ON DEFAULTS:
* If you don't specify any parameters, **choco-persistent-packages** defaults to running daily at midnight and aborting at 1 AM. (My preference!)
* Not specifying a TIME will always default to midnight. Not specifying an ABORTTIME will always default to 1 AM. If you're setting a TIME, be sure to also set the ABORTTIME. 

###POST INSTALL INSTRUCTIONS:
* Edit \ProgramData\Chocolatey\config\persistentpackages.config and read the comments section.

If you have a previous release of **choco-persistent-packages** installed, upgrading to a new version will NOT modify your current scheduled task or list of persistent packages. You will need to uninstall and re-install to take advantage of the new ABORTTIME feature.

CHANGELOG:
* 2018.05.06 - Added abort stuck upgrades feature. "Um, why do I want this?" you're thinking. You want this because sometimes background package installations go wrong. "Go wrong?" you're thinking. Yes, there are a couple scenarios where a Chocolatey package installation/upgrade can hang: if a package needs input, if an AutoHotKey or AutoIt script fails, and all those times a program installer pops up a browser window to tell you "Thank you." These scenarios leave hung processes in the background with no way for you to easily interact with them (They're in the background!). This means they are taking up memory resources for no reason and might cause problems installing other packages or programs. **If** you knew there was a hung process, you could manually stop the task, but who wants to check every day? This will automate checking and stopping any Chocolatey package hung tasks at the time you specify. I recommend setting it to a time an hour or two after you run your updates. 
* 2018.04.23 - Fixed compatibility with Windows 7 & 8 machines by using SchTasks.exe for everything and not using the Windows 10/Server 2016 only get-scheduledtask cmdlet. Removed PowerShell v4/v5 dependency. 
* 2017.08.20.01 - Updated Chocolatey/nuspec description to correct INSTALL EXAMPLES. Added message post install to edit persistentpackages.config. Added shortcut to persistentpackages.config in tools dir.

***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3)? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>