# Chocolatey Packages

[![](https://ci.appveyor.com/api/projects/status/github/pauby/chocopackages?svg=true)](https://ci.appveyor.com/project/pauby/chocopackages)
[Update status](https://gist.github.com/pauby/e3b29a09c77246998b82c9ad33f4be4a)

This contains my packages, both manually and automatically maintained through [Appveyor](https://www.appveyor.com/).

### Folder Structure

* automatic - where automatic packaging and packages are kept. These are packages that are automatically maintained using either [AU](https://chocolatey.org/packages/au).
* icons - Where you keep icon files for the packages. This is done to reduce issues when packages themselves move around.
* manual - where packages that are not automatic are kept.
* scripts - scripts, jobs, and other items for ensuring automatic packaging.
* setup - items for prepping the system to ensure for auto packaging.

For setting up your own automatic package repository, please see [Automatic Packaging](https://chocolatey.org/docs/automatic-packages)

### Requirements

* Chocolatey (choco.exe)

#### AU

* PowerShell v5+.
* The [AU module](https://chocolatey.org/packages/au).

For daily operations check out the AU packages [template README](https://github.com/majkinetor/au-packages-template/blob/master/README.md).
