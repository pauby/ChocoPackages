# [keepass-plugin-haveibeenpwned](https://chocolatey.org/packages/keepass-plugin-haveibeenpwned)

KeePass 2.x plugin to check all entries with URLs against various breach lists.

## Currently Supported Breach Lists

### Site/Domain based

* Have I Been Pwned (HIBP) - Checks the domains of any entries against the Have I Been Pwned? list curated by Troy Hunt.
* Cloudbleed vulnerability list - Checks the domains of any entries that appear in the Cloudbleed vulnerability list. This has potential to produce false positives due to the way this list was produced.

### Username based

* Have I Been Pwned (HIBP) - Checks the usernames of any entries against the Have I Been Pwned? list curated by (Troy Hunt)[https://www.troyhunt.com/]. This service requires you to register for an API key via https://haveibeenpwned.com/API/Key . The cost of API key is $3.50 per month (Credit card required).

### Password based

* Have I Been Pwned (HIBP) - Checks the passwords of any entries against the Have I Been Pwned? list curated by Troy Hunt.

This checker sends a small portion of the password hash to HIBP and then checks the full hash locally against the list of hashes returned by HIBP. This service does not send your password, nor enough of the hash to expose your password to HIBP.

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.