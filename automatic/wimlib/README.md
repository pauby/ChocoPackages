# ![wimlib](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@7b92203e/icons/wimlib.png "wimlib") [wimlib](https://chocolatey.org/packages/steam)

wimlib is an open source, cross-platform library for creating, extracting, and modifying Windows Imaging (WIM) archives. WIM is a file archiving format, somewhat comparable to ZIP (and many other file archiving formats); but unlike ZIP, it allows storing various Windows-specific metadata, allows storing multiple "images" in a single archive, automatically deduplicates all file contents, and supports optional solid compression to get a better compression ratio. wimlib and its command-line frontend wimlib-imagex provide a free and cross-platform alternative to Microsoft's WIMGAPI, ImageX, and DISM.

Among other things, wimlib:

* Provides fast and reliable file archiving on Windows and on UNIX-like systems such as Mac OS X and Linux.
* Allows users of non-Windows operating systems to read and write Windows Imaging (WIM) files.
* Supports correct archiving of files on Windows-style filesystems such as NTFS without making common mistakes such as not properly handling ACLs, file attributes, links, and named data streams.
* Allows deployment of Windows operating systems from non-Windows operating systems such as Linux.
* Provides independent, high quality open source compressors and decompressors for several compression formats used by Microsoft which are not as well known as more open formats, and are prone to be re-used in different applications and file formats (not just WIM).

wimlib is distributed either as a source tarball (for UNIX/Linux), or as ready-to-use binaries (for Windows XP and later). The software consists of a C library along with the wimlib-imagex command-line frontend and its associated documentation. 

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.