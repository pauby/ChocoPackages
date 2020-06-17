# [KeePass Plugin KeeTrayTOTP(https://chocolatey.org/packages/keepass-plugin-keetraytotp)

This plugin is for those who already use [Tray TOTP Plugin](http://sourceforge.net/projects/traytotp-kp2/), but also want to use with Valve's Steam.

> This is a fork of the Tray TOTP Plugin for KeePass2. Originally developed by [Morphlin](http://sourceforge.net/u/morphlin/profile/). The original source code and plugin can be found on [Sourceforge](http://sourceforge.net/projects/traytotp-kp2/).

Most of consumer TOTP's use the RFC6238 output style, sadly some companies (eg. Valve) decided not to adhere to the standard and instead build their own format.

In the case of Steam Mobile Authenticator the new output format was reverse engineered by various developers, and alternatives to it started popping up, most do pretty good job and can by themselves recover the TOTP secret (which is no easy task given Valve's implementation).

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.