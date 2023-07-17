This package was moved from automatic, to manual as the Adobe website that it tries to connect to in the `update.ps1` script, requires HTTP/2 to work. HTTP/2 is not used by POwerShell 5.1, but is in [PowerShell 7.30-preview.1 and above](https://github.com/PowerShell/PowerShell/issues/12641#issuecomment-996152209).

So in Windows PowerShell 5.1, `iwr https://www.adobe.com/solutions/ebook/digital-editions/download.html -UseBasicParsing` times out. But `Invoke-WebRequest https://www.adobe.com/solutions/ebook/digital-editions/download.html -HttpVersion 2` works right away.

`capu` does not run in PowerShell Core, and the AppVeyor runner uses Windows PowerShell so to get this working would require some fundamental changes
