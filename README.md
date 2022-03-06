# Chocolatey Packages

This contains my packages, both manually and automatically maintained through [Appveyor](https://www.appveyor.com/).

Thanks to [@AdmiringWorm](https://github.com/AdmiringWorm) and the [Chocolatey Community Packages Repository](https://github.com/chocolatey-community/chocolatey-packages) for the repository templates and stale GitHub Workflow. I shamelessly borrowed the work done over there and tweaked it for here.

### Folder Structure

* automatic - where automatic packaging and packages are kept. These are packages that are automatically maintained using [capu](https://github.com/pauby/capu/).
* icons - Where you keep icon files for the packages. This is done to reduce issues when packages themselves move around.
* manual - where packages that are not automatic are kept.
* scripts - scripts, jobs, and other items for ensuring automatic packaging.
* setup - items for prepping the system to ensure for auto packaging.

For setting up your own automatic package repository, please see [Automatic Packaging](https://chocolatey.org/docs/automatic-packages)

### Requirements

* Chocolatey (choco.exe)

## Etiquette Regarding Communication

Please remember that maintainers of packages are volunteers that have lives outside of open source and are not paid to ensure things work for you, so please be considerate of others' time when you are asking for things. Many of us have families that also need time as well and only have so much time to give on a daily basis. A little consideration and patience can go a long way. After all, you are using packages that have been developed for free using time, energy and goodwill.
