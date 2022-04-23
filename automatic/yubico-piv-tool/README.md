# [Yubico PIV Tool](https://chocolatey.org/packages/yubico-piv-tool)

The Yubico PIV tool is used for interacting with the Personal Identity Verification (PIV) application on a YubiKey.

With it you may generate keys on the device, importing keys and certificates, and create certificate requests, and other operations. A shared library and a command-line tool is included.

## What Is PIV?

PIV, or FIPS 201, is a US government standard. It enables RSA or ECC sign/encrypt operations using a private key stored on a smartcard (such as the YubiKey NEO), through common interfaces like PKCS#11.

You can read more about the PIV standards here: http://csrc.nist.gov/groups/SNS/piv/standards.html

PIV is primarily used for non-web applications. It has built-in support under Windows, and can be used on OS X and Linux via the OpenSC project.

## Notes

- Yubikey uses letters after some versions (so you might get 1.4.2g). This doesn't work for versions here so the letter is converted to its ASCII value. So if the software version is 1.4.2g then the version here will be 1.4.2.103 (as 103 is the ASCII value for g).
- This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.
