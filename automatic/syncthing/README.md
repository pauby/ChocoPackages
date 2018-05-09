# ![Syncthing](https://cdn.rawgit.com/pauby/ChocoPackages/9ffd3adf/icons/syncthing.png "Syncthing Logo") [Syncthing](https://chocolatey.org/packages/syncthing)

Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized. Your data is your data alone and you deserve to choose where it is stored, if it is shared with some third party and how it's transmitted over the Internet

This package contains only the CLI program to be launched from the terminal.

If you want to add syncthing as a service that runs at system startup, execute the following command from PowerShell with administrator permissions.

```
New-Service Syncthing $env:ChocolateyInstall/bin/syncthing.exe -StartupType Automatic
Start-Service Syncthing
```