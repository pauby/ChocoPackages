# ![Git-Credential-Manager-For-Windows](https://cdn.rawgit.com/pauby/ChocoPackages/69f57827/icons/git-credential-manager-for-windows.png "Git Credential Manager For Windows Logo") [Git-Credential-Manager-For-Windows](https://chocolatey.org/packages/git-credential-manager-for-windows)

The Git Credential Manager for Windows (GCM) provides secure Git credential storage for Windows. It's the successor to the Windows Credential Store for Git (git-credential-winstore), which is no longer maintained. Compared to Git's built-in credential storage for Windows (wincred), which provides single-factor authentication support working on any HTTP enabled Git repository, GCM provides multi-factor authentication support for Visual Studio Team Services, Team Foundation Server, and GitHub.

This project includes:

* Secure password storage in the Windows Credential Store
* Multi-factor authentication support for Visual Studio Team Services
* Two-factor authentication support for GitHub
* Personal Access Token generation and usage support for Visual Studio Team Services and GitHub
* Non-interactive mode support for Visual Studio Team Services backed by Azure Directory
* Kerberos authentication for Team Foundation Server (see notes)
* Optional settings for build agent optimization

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.