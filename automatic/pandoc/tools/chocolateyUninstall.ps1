$ErrorActionPreference = 'Stop'

'pandoc', 'pandoc-citeproc.exe' | % { Uninstall-BinFile $_ }