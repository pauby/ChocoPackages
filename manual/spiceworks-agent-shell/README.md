# ![Spiceworks Agent Logo](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@ad9fd8dd/icons/spiceworks-agent-shell.png "Spiceworks Agent Logo") [Spiceworks Agent](https://chocolatey.org/packages/spiceworks-agent)

Spiceworks Agent is a tool that allows IOD IT Administrators to view details about your computer's configuration - What software is installed, if your anti-virus software is up to date, how much memory is in your machine, etc.  The information collected is used for a variety of purposes, such as:

* Determining when your machine needs to be replaced or upgraded
* Tracking when your machine's warranty expires
* Tracking when your computer is having hardware malfunctions.

NOTE: This package will fail to install without providing a [site key](https://resolve.spiceworks.com/#/login) at the time of install using the following parameter:

    `/sitekey:"&lt;your site key&gt;"`

Example:

    `-packageParameters='"/sitekey:ABcdefGHiJKLmnoPQRSt"'`
