# ![Snagit](https://cdn.jsdelivr.net/gh/pauby/chocopackages/icons/snagit.png "Snagit Logo") [Snagit](https://chocolatey.org/packages/snagit)

Snagit is a image capture program from TechSmith.

## Beyond ordinary screen capture

Snagit's award-winning screen capture software is the only program with built-in advanced image editing and screen recording.

## Capture anything on your screen

Snagit makes it easier and more intuitive to capture your screen or record video. Capture your entire desktop, region, window, or scrolling screen.

## Edit with a few clicks

Get a full suite of editing tools. And create images on your own. Edit screenshots or build custom graphics. Without needing to work with a designer.

## Deliver results

The human brain processes visuals 60,000 times faster than text. Snagit makes it easy to add videos and images to your email, training materials, documentation, blogs, or social media. Or get a short URL to share your screenshots and recordings with anyone.

## Snagit integrates with the tools you use

* Microsoft PowerPoint
* Microsoft Word
* Microsoft Excel
* Microsoft OneDrive for Business
* Google Drive
* ... and more

NOTE: This is a trial install of Snagit. To use your license key see Parameters below.

## Parameters

* /licensekey=ABCD-EFGH-IJKL
  Registered license key. If this is missing a 30 day trial is installed.

Example: **--params='"/licensekey=ABCD-EFGH-IJKL"'**

* /NoDesktopShortcut
  Does not install an application shortcut on the desktop. Note Snagit no longer creates a desktop icon by default so this option no longer does anything,

* /DisableAutoStart
  This disables Snagit from automatically starting with Windows.

  Example: **--params='"/DisableAutoStart"'**

* /DisableStartNow
  This disables Snagit from starting right after installation / upgrade.

  Example: **--params='"/DisableStartNow"'**

* /HideRegistrationKey
  Prevents Snagit from displaying the registration key in the Help menu > About Snagit > Support Information dialog.

  Example: **--params='"/HideRegistrationKey"'**

* /Language='ENU' | 'DEU' | 'ESP' | 'FRA' | 'JPN' | 'PTB'
 Choose the language Snagit will use with one of these values (English, German, Spanish, French, Japanese or Portugese).

  Example: **--params='"/Language=JPN"'**

## Notes

* TechSmith seem to be okay with releasing a new version of the same version. This throws out the checksum of the package. Until the next version is released, please use the `--ignore-checksums` switch with Chocolatey CLI.
* This package installs the Microsoft WebView2 Runtime. However, it will not be removed on uninstall so please remove it manually.
* This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.
