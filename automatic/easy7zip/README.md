# Easy 7-Zip

Briefly speaking, Easy 7-Zip is an easy-to-use version of 7-Zip. Originally, Easy 7-Zip was built based on 7-Zip 9.20. I kept all features of 7-Zip and added a few useful features that makes the software more user-friendly. Recently, 7-Zip upgraded to 16.04. So, I moved codes to the version.

7-Zip is a free and great file decompression and compression software that handles 7z, AR, ARJ, BZIP2, CAB, CHM, CPIO, CramFS, DEB, DMG, EXT, FAT, GPT, GZIP, HFS, IHEX, ISO, LZH, LZMA, MBR, MSI, NSIS, NTFS, QCOW2, RAR, RAR5, RPM, SquashFS, TAR, UDF, UEFI, VDI, VHD, VMDK, WIM, XAR, XZ, Z, ZIP, and ZIPX archives. 7-Zip was developed by Igor Pavlov.
Why did I make Easy 7-Zip?

7-Zip is a great file archive freeware. I love the software very much. Thank Igor Pavlov! However, when I used the 7-Zip frequently, I thought the software could be better. So, I downloaded source code of 7-Zip and, studied and modified the code in my leisure time, and made the Easy 7-Zip. I hope the Easy 7-Zip is useful for everybody.

# What features were added to Easy 7-Zip?

1 Adds icons to context menu.

2 Adds options to Extract dialog.
  * Button "Open": Easy 7-Zip will open output folder when clicking on the button. 
  * Button "Filename": When the button is clicked, Easy 7-Zip adds file name to end of output folder so that the program will create folder of file name and extract files to the folder.
  * Show free and total space of output drive. It's useful for large file.
  * Options "After extraction completes successfully":
    * Open output folder: If the option is checked, Easy 7-Zip opens output folder after extraction.
    * Delete source archive: Delete source archive after extraction completes successfully.
    * Close 7-Zip: Close 7-Zip after extraction.

3 Keeps same output folder history

4 Minimizes to system tray when clicking "Background" on progress dialog

5 Makes a new installation file

I made a package of Easy 7-Zip that contains both x86 (32-bit) and x64 (64-bit) editions. In other word, the package installs x86 (32-bit) edition of Easy 7-Zip on 32-bit Windows and x64 (64-bit) edition on 64-bit Windows automatically. The package also allows user to associate 7-Zip with file extensions including 001, 7z, arj, bz2, bzip2, cab, cpio, deb, dmg, fat, gz, gzip, hfs, iso, lha, lzh, lzma, ntfs, rar, rpm, squashfs, swm, tar, taz, tbz2, tbz, tgz, tpz, txz, vhd, wim, xar, xz, z, and zip.

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.