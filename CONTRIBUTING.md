# Contributing

**Please make sure you read over this entire document prior to contributing. It is a work in progress and not everything has been covered.**

The packages within this repository are maintained in my spare time. My spare time, like yours is important. Please help me not to waste it.

The majority of the packages are automated and will update themselves. Note that when a package is updated, the updated files are not pushed back to this repository. **This is important to understand.** When you see an old version in the package `.nuspec` file, it is intentional. It does not reflect that the package on the [Chocolatey Community Repository](https://community.chocolatey.org) or confirmation that it is outdated.

## Etiquette Regarding Communication

Please remember that maintainers of packages are volunteers that have lives outside open-source and are not paid to ensure things work for you, so please be considerate of others' time when you are asking for things. Many of us have families that also need time as well and only have so much time to give on a daily basis. A little consideration and patience can go a long way. After all, you are using packages that have been developed for free using time, energy and goodwill.

## Repository Structure

The root folders in the repository have a purpose:

* automatic - where automatic packaging and packages are kept. These are packages that are automatically maintained using [capu](https://github.com/pauby/capu/).
* icons - Where you keep icon files for the packages. This is done to reduce issues when packages themselves move around.
* manual - where packages that are not automatic are kept.
* scripts - scripts, jobs, and other items for ensuring automatic packaging.
* setup - items for prepping the system to ensure for auto packaging.

## Package Outdated?

If the package is outdated, please ensure:

- You have checked the **Version History** section of the package page to ensure no new version has already been submitted.
- The package has been outdated for _at least_ 2 days.

If you haven't done this, the issue will be closed. See the above about helping me not waste my time.

If the package is indeed outdated, the automation has likely stopped working. This can happen if whatever I am doing to detect the version changes.

## Broken Package? Package Problems?

To fix a bug, add a feature, improve or update a package please read see [updating packages](#updating-packages). Once you have done that, you can submit a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) to help me out.

## Have A Question?

Please don't raise an issue to ask a question. Please [open a discussion](/${{ github.repository }}/discussions/)

## Updating Packages

If you want to help fix an issue, or improve a package, thank you!

### Updating Packages in the `automatic` Folder

The packages in the `automatic` folder, in the root of the repository, are automated using [`capu`](https://github.com/pauby/capu) and will update themselves automatically.
Note that when a package is updated, the updated files are not pushed back to this repository. This is important.
If you are updating one of these packges, ensure:

1. You have **not** updated the description field in the package .nuspec file. The package description is taken from the `README.md` file in the package folder. If you need to update the description, update this file instead.
1. You have **not** updated the checksums in the `chocolateyInstall.ps1` file. The checksums are generated automatically by the `update.ps1` file in the package folder.
1. You have **not** updated the download URL's in the `chocolateyInstall.ps1` file. These are generated automatically by the `update.ps1` file in the package folder.
1. As a catch-all, ensure you are not updating anything that is updated by the `update.ps1` file.

### Updating packages in the `manual` Folder

The packages in the `manual` folder in the root of the repository are not automated, are updated, and pushed, manually. There are no requirements for these packages, like there are for packages in the `automatic` folder.
