# ![Npcap](https://cdn.jsdelivr.net/gh/pauby/chocopackages@b89170b/icons/npcap.png< "Npcap") [Npcap](https://chocolatey.org/packages/npcap)

Npcap is the Nmap Project's packet capture (and sending) library for Microsoft Windows. It implements the open Pcap API using a custom Windows kernel driver alongside our Windows build of the excellent libpcap library. This allows Windows software to capture raw network traffic (including wireless networks, wired ethernet, localhost traffic, and many VPNs) using a simple, portable API. Npcap allows for sending raw packets as well. Mac and Linux systems already include the Pcap API, so Npcap allows popular software such as Nmap and Wireshark to run on all these platforms (and more) with a single codebase. Npcap began in 2013 as some improvements to the (now discontinued) WinPcap library, but has been largely rewritten since then with hundreds of releases improving Npcap's speed, portability, security, and efficiency. In particular, Npcap now offers:

* Loopback Packet Capture and Injection
* Support for all Current Windows Releases
* Libpcap API
* Support for all Windows architectures (x86, x86-64, and ARM)
* Extra Security
* WinPcap compatibility
* Raw (monitor mode) 802.11 wireless capture

The free version of Npcap may be used (but not externally redistributed) on up to 5 systems (free license details). It may also be used on unlimited systems where it is only used with Nmap, Wireshark, and/or Microsoft Defender for Identity. See the [website for details on Npcap OEM for Commercial Use and Redistribution](https://npcap.com).

## Notes

* To allow the installation to be automated, a deppendency on [autohotkey.portable](https://community.chocolatey.org/packages/autohotkey.portable) v2.0.0 or later is used.
* This is NOT an automatically updated package. If you find it is out of date, please contact the maintainer(s) and let them know.
* I am unable to answer comments left on Disqus. If you have something related to the **_package_**:
  1. Raise a [discussion](https://github.com/pauby/chocopackages/discussions) for questions.
  2. Raise an [issue](https://github.com/pauby/chocopackages/issue) for a broken package.
