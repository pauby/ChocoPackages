# ![pdfFactory Pro Workstation](https://cdn.rawgit.com/pauby/ChocoPackages/6024a73d/icons/pdffactorypro-workstation.png "pdfFactory Pro Workstation") [pdfFactory Pro Workstation](https://chocolatey.org/packages/pdffactorypro-workstation)

Easy, reliable PDF creation from all applications.

You can pass the following parameters:

* UI language: `/lang:[LANGUAGE]`
* License code: `/license:[YOUR LICENSE CODE]`
* Name of the license holder - this is ignored if no license code has been specified: `/name:"[YOUR NAME]"`
* Printer margins in 1/100th of an inch: `/margins:"[TOP] [RIGHT] [BOTTOM] [LEFT]"`

Available languages are:

* Chinese (Simplified): `zh-CN`
* Chinese (Traditional): `zh-TW`
* Czech: `cs`
* Danish: `da`
* Dutch: `nl`
* English: `en`
* French: `fr`
* German: `de`
* Italian: `it`
* Japanese: `ja`
* Polish: `pl`
* Portuguese: `pt`
* Russian: `ru`
* Slovak: `sk`
* Spanish: `es`
* Swedish: `sv`


Example:

`-params '"/lang:en /license:ABCDE-12345-FGHIJ /name:""John Doe"" /margins:""0 0 0 0"""'`

NOTE: This package installs a printer driver. If you have UAC prompts enabled, you will need to confirm the driver installation.
