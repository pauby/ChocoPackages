# [Jump-Location](https://chocolatey.org/packages/jump-location)

If you spend any time in a console you know that `cd` is by far the most common command that you issue. I'll open up a console to it's default location in `C:\Users\tkellogg` or `C:\Windows\system32` and then issue a `cd C:\work\MyProject`. `Set-JumpLocation` is a cmdlet lets you issue a `j my` to jump directly to `C:\work\MyProject`.

It learns your behavior by keeping track of how long you spend in certain directories and favoring them over the ones you don't care about. You don't have to use `Jump-Location` as a replacement for `cd`. Use `cd` to go local, and use `Set-JumpLocation` to jump further away.

`Jump-Location` is a PowerShell implementation of autojump.

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.