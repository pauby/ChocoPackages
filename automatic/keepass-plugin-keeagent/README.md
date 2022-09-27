# ![KeePass Plugin KeeAgent](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@4d273685/icons/keepass-plugin-keeagent.png "KeePass Plugin KeeAgent") [KeePass Plugin KeeAgent](https://chocolatey.org/packages/keepass-plugin-keeagent)

KeeAgent is a plugin for KeePass 2.x. It allows other programs to access SSH keys stored in your KeePass database for authentication. It can either act as a stand-alone agent or it can interface with an external agent.

* Store your SSH private keys in your KeePass 2.x database and use KeePass as your SSH agent (replaces Pageant on Windows).
* Keys can be configured to automatically load when a KeePass database is opened and unload when the database is closed/locked.
* Cross-platform: work on Windows/Linux/Mac.
* Supports both PuTTY and OpenSSH private key formats, (new in Beta v0.7.0, includes the “new” OpenSSH key format introduced in OpenSSH 6.5).
* Supports SSH1 and SSH2 keys.
* SSH2 key formats include RSA, DSA and ECDSA (new in Beta v0.7.0, includes Ed25519 support).
* Works with both PuTTY (and PuTTY compatible programs) and Cygwin/Msys on Windows.
* Works with native SSH agent on Linux/Mac.

**NOTE**: This package will not install unless you have either `keepass`, `keepass.install` or `keepass.portable` installed.
**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.