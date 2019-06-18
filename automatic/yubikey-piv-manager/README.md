# ![Yubikey PIV Manager](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@8002542d/icons/yubikey-piv-manager.png "Yubikey PIV Manager Logo") [Yubikey PIV Manager](https://chocolatey.org/packages/yubikey-piv-manager)

Graphical application for configuring a PIV-enabled YubiKey.

![Screenshot](https://github.com/pauby/chocopackages/tree/master/automatic/yubikey-piv-manager/screenshot.png)

## What Is PIV?

PIV, or FIPS 201, is a US government standard. It enables RSA or ECC sign/encrypt operations using a private key stored on a smartcard (such as the YubiKey NEO), through common interfaces like PKCS#11.

You can read more about the PIV standards here: http://csrc.nist.gov/groups/SNS/piv/standards.html

PIV is primarily used for non-web applications. It has built-in support under Windows, and can be used on OS X and Linux via the OpenSC project.

**NOTE**: Yubikey uses letters after some versions (so you might get 1.4.2g). This doesn't work for versions here so the letter is converted to its ASCII value. So if Yubikeys version is 1.4.2g then the version here will be 1.4.2.103 (as 103 is the ASCII value for g).

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.