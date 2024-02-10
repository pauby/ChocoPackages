<img src="https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/mylogos/myunofficialChocolateylogo_icon.png" width="139" height="88">

**BCURRAN3'S PACKAGE NOTES:**

* A BCURRAN3 original!
* I personally (will) use and endorse this extension.

#**Chocolatey Fast Answers Extension** is a Chocolatey extension for use as a dependency by package maintainers.

#Purpose
To provide (fairly) easy to remember micro functions for (new?) package creators/maintainers to get short fast answers to common decision tree questions that come up during package creation. The majority of functions return True/False. None of the functions are complex and most rely on WMI. By using this Chocolatey extension you can easily script situations such as aborting an install for a package/program that doesn't work on servers by checking first using Get-IsWinServer or conversely Get-IsWinWorkstation. Maybe you have a package that needs to make sure there is not a pending reboot and you can check using Get-PendingReboot and error out with a message explaining to reboot and try again. Maybe you have a package that only runs on Windows 10 and Windows Server 2016, you can easy check at the beginning of your script using Get-IsWin10 or Get-IsWinServer2016. 

...and yes, nobody will probably use Get-IsSSD except me for some non-Chocolatey scripts! :) 
(Though IMHO defrag packages should abort if a SSD is found and warn that it's not recommended to defrag a SSD.)

The use cases go on...

#Functions
![List of functions](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/chocolatey-fastanswers.extension/List_of_functions.png)

Screenshot testing all functions with simple test-package install script that does: $test=function and Write-Out function result for each function. Results from the functions show that the test package was run on a computer with Microsoft Windows 10 Pro build 16299 64bit, joined to a domain, (onboard) Intel video, (discreet) Nvidia video, has a SSD, is a workstation not a server, and is pending a reboot.
![](https://cdn.staticaly.com/gh/bcurran3/ChocolateyPackages/master/chocolatey-fastanswers.extension/chocolatey-fastanswers.extension.png)

###CHANGE LOG:
* 0.0.2 - Added Get-IsAMDCPU, Get-IsARMCPU, Get-IsHyperV, Get-IsIntelCPU, Get-IsKVM, Get-IsMobile, Get-NuspecInfo, Get-IsWinServer2019, and Get-IsXen. Improved Get-IsVM, Get-IsWin7/8/80/81/10, Get-IsWinServer2016, and Get-IsVMware. Bug fixed in Get-IsWin8 and Get-IsWin81.
* 0.0.1 - initial release

###ROADMAP:
* Possibly add more version checking functions such as Get-IsGEWin8 (Or Get-IsMin8?) for quick checking minimums. 
* Am open to any useful suggestions/additions!

***

Like my [original Chocolatey add-ons and packages](https://community.chocolatey.org/packages?q=tag%3Abcurran3)? or my [400+ other program packages](https://chocolatey.org/profiles/bcurran3)? Find them useful? Appreciate my hard work, time, and effort?


<h1>How about buying me a <img src="https://cdn.rawgit.com/bcurran3/ChocolateyPackages/master/mylogos/beer.png" alt="" width="40" height="40"> via PayPal?</h1>

[![PayPal Donate](https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg)](https://www.paypal.me/bcurran3donations)

<h1>Better yet... Keep me incentivized by Patreonizing me!</h1>

[![Patreonize me!](https://c5.patreon.com/external/logo/downloads_wordmark_white_on_coral.png)](https://www.patreon.com/bcurran3)


If applicable, please always consider donating or purchasing the software you installed - including [Chocolatey's licensed editions](https://chocolatey.org/pricing).

<h3>TIA,</h3>

<h3>Bill</h3>