# [Firefox Quantum Nox](https://chocolatey.org/packages/firefox-quantum-nox)

This package allows you patch Firefox to enable the use of external Javascript files to extend it's functionability. Some of the features you can install are multirow tabs, tabs below, or focus tab on hover.

### How To Use

This package drops the Firefox Quantum Nox binary into the tools folder and calls it `quantum-nox.exe`. It will also be shimmed so can be run directly from the PATH.

You can execute the `quantum-nox.exe`, with [parameters](https://github.com/Izheil/Quantum-Nox-Firefox-Dark-Full-Theme/wiki/Installer-console-commands) while installing the package. Anything you pass to Chocolatey in the `--params` parameter will be passed unaltered. So for example `choco install firefox-quantum-nox --params="'--multirow --multirow-version 2 --megabar'"` will run `quantum-nox.exe --multirow --multirow-version 2 --megabar` at the package install time. To run any commands after the package has been installed just run `quantum-nox.exe` with the parameters, from the command line.

### Virus Detections

The binary is a wrapped Python script and because of this, has been detected by various AV scanners. See [this issue](https://github.com/Izheil/Quantum-Nox-Firefox-Dark-Full-Theme/issues/54) for more information.

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.