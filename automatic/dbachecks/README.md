# ![dbachecks Logo](https://cdn.jsdelivr.net/gh/pauby/chocopackages/icons/dbachecks.png "dbachecks")[dbachecks](https://chocolatey.org/packages/dbachecks)

dbachecks is a framework created by and for SQL Server pros who need to validate their environments. Basically, we all share similar checklists and mostly just the server names and RPO/RTO/etc change.

This open source module allows us to crowd-source our checklists using Pester tests. Such checks include:

* Backups are being performed
* Identity columns are not about to max out
* Servers have access to backup paths
* Database integrity checks are being performed and corruption does not exist
* Disk space is not about to run out
* All enabled jobs have succeeded

Have questions about development? Please visit our [Wiki](https://github.com/sqlcollaborative/dbachecks/wiki). **Anyone developing this module should visit that Wiki page (after fully reading this readme) for a brief overview**.

_**NOTE: This module requires a minimum of PowerShell v4.**_

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.
