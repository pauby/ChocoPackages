# Easy 7-Zip

Briefly speaking, Easy 7-Zip is an easy-to-use version of 7-Zip. Originally, Easy 7-Zip was built based on 7-Zip 9.20. I kept all features of 7-Zip and added a few useful features that makes the software more user-friendly. Recently, 7-Zip upgraded to 16.04. So, I moved codes to the version.

7-Zip is a free and great file decompression and compression software that handles 7z, AR, ARJ, BZIP2, CAB, CHM, CPIO, CramFS, DEB, DMG, EXT, FAT, GPT, GZIP, HFS, IHEX, ISO, LZH, LZMA, MBR, MSI, NSIS, NTFS, QCOW2, RAR, RAR5, RPM, SquashFS, TAR, UDF, UEFI, VDI, VHD, VMDK, WIM, XAR, XZ, Z, ZIP, and ZIPX archives. 7-Zip was developed by Igor Pavlov.
Why did I make Easy 7-Zip?

7-Zip is a great file archive freeware. I love the software very much. Thank Igor Pavlov! However, when I used the 7-Zip frequently, I thought the software could be better. So, I downloaded source code of 7-Zip and, studied and modified the code in my leisure time, and made the Easy 7-Zip. I hope the Easy 7-Zip is useful for everybody.

# What features were added to Easy 7-Zip?

## 1. Adds icons to context menu.

* Note: just for 7-Zip 9.20. The latest version (16.04) of 7-Zip has added the feature.

When I was using WinZip or WinRAR, I can easily find menu items of WinZip or WinRAR in context menu of Explorer. As there are icons with the menu items. However, 7-Zip doesn't offer the feature. So I decided to add the feature first. When it's done, the context menu looks like the following screen shots.

## 2. Adds options to Extract dialog.

I added 4 features to the extract dialog in 7-Zip File Manager.

1. Button "Open": Easy 7-Zip will open output folder when clicking on the button. So you can easily view files or directories in the folder by a click.
2. Button "Filename": When the button is clicked, Easy 7-Zip adds file name to end of output folder so that the program will create folder of file name and extract files to the folder. For example, file name is sample.7z, output folder is D:\Output, when clicking the button, the output folder will be D:\Output\sample, and all files will be outputted to the folder.
3. Show free and total space of output drive. It's useful for large file.
4. Options "After extraction completes successfully":
    * Open output folder: If the option is checked, Easy 7-Zip opens output folder after extraction. So that you can locate to the output files easily.
    * Delete source archive: Delete source archive after extraction completes successfully. If any errors happen while extracting, for example, wrong password, the Easy 7-Zip won't delete the source archive.
    * Close 7-Zip: Close 7-Zip after extraction.

## 3. Keeps same output folder history

7-Zip uses separated output folder history for extract dialog of 7-Zip File Manager and context menu. However, we probably use either way to extract file and we can't find output folder history of another. I made Easy 7-Zip uses same output folder history for the both extract dialogs and extends number of output folder history up to 30.

## 4. Minimizes to system tray when clicking "Background" on progress dialog

It's something like the 7-Zip does nothing when clicking on "Background" in original 7-Zip. Actually the 7-Zip sets progress priority of itself to idle. So user could do other things without performance loss on the same computer. However, it could be better if the 7-Zip minizes to system tray when background working. I got the feature possible in Easy 7-Zip. The program shows progress in system tray as well.

I also added percent of progress to the dialog, although the percent shows in title of the dialog. As I don't get used to see the percent in dialog title.

## 5. Makes a new installation file

I made a package of Easy 7-Zip that contains both x86 (32-bit) and x64 (64-bit) editions. In other word, the package installs x86 (32-bit) edition of Easy 7-Zip on 32-bit Windows and x64 (64-bit) edition on 64-bit Windows automatically. The package also allows user to associate 7-Zip with file extensions including 001, 7z, arj, bz2, bzip2, cab, cpio, deb, dmg, fat, gz, gzip, hfs, iso, lha, lzh, lzma, ntfs, rar, rpm, squashfs, swm, tar, taz, tbz2, tbz, tgz, tpz, txz, vhd, wim, xar, xz, z, and zip.