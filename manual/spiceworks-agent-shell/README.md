# ![Spiceworks Agent Logo](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@ad9fd8dd/icons/spiceworks-agent-shell.png "Spiceworks Agent Logo") [Spiceworks Agent](https://chocolatey.org/packages/spiceworks-agent)

Spiceworks Agent is a tool that allows IOD IT Administrators to view details about your computer's configuration - What software is installed, if your anti-virus software is up to date, how much memory is in your machine, etc.  The information collected is used for a variety of purposes, such as:

* Determining when your machine needs to be replaced or upgraded
* Tracking when your machine's warranty expires
* Tracking when your computer is having hardware malfunctions.

NOTE: This package will fail to install without providing a [site key](https://resolve.spiceworks.com/#/login) at the time of install using the following parameter:

    `/sitekey:"&lt;your site key&gt;"`

Example:

    `-packageParameters='"/sitekey:ABcdefGHiJKLmnoPQRSt"'`

    * This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Notes

* I am unable to answer comments left on Disqus. If you have something related to the **_package_**:
  1. Raise a [discussion](https://github.com/pauby/chocopackages/discussions) for questions.
  2. Raise an [issue](https://github.com/pauby/chocopackages/issues) for a broken package.
