# # ![Virtualbox Logo](https://cdn.jsdelivr.net/gh/pauby/chocopackages/icons/virtualbox-guest-additions.install.png "Virtualbox Logo")[Virtualbox Guest Additions Install](https://chocolatey.org/packages/virtualbox-guest-additions.install)

**NOTE**: This package should be installed _inside your guest Windows VM_ and is useful for automating the building of Virtualbox VM's. It is _not_ meant to be installed on the host.

The Guest Additions are designed to be installed inside a virtual machine after the guest operating system has been installed. They consist of device drivers and system applications that optimize the guest operating system for better performance and usability.

The Guest Additions offer the following features:

* **Mouse pointer integration**. To overcome the limitations for mouse support described in Section 1.9.2, “Capturing and Releasing Keyboard and Mouse”, this feature provides you with seamless mouse support. You will only have one mouse pointer and pressing the Host key is no longer required to "free" the mouse from being captured by the guest OS.
* **Shared folders**. These provide an easy way to exchange files between the host and the guest. Much like ordinary Windows network shares, you can tell Oracle VM VirtualBox to treat a certain host directory as a shared folder, and Oracle VM VirtualBox will make it available to the guest operating system as a network share, irrespective of whether guest actually has a network.
* **Better video support**. While the virtual graphics card which Oracle VM VirtualBox emulates for any guest operating system provides all the basic features, the custom video drivers that are installed with the Guest Additions provide you with extra high and non-standard video modes, as well as accelerated video performance.
  In addition, with Windows, Linux, and Oracle Solaris guests, you can resize the virtual machine's window if the Guest Additions are installed. The video resolution in the guest will be automatically adjusted, as if you had manually entered an arbitrary resolution in the guest's Display settings.
* **Seamless windows**. With this feature, the individual windows that are displayed on the desktop of the virtual machine can be mapped on the host's desktop, as if the underlying application was actually running on the host.
* **Generic host/guest communication channels**. The Guest Additions enable you to control and monitor guest execution. The "guest properties" provide a generic string-based mechanism to exchange data bits between a guest and a host, some of which have special meanings for controlling and monitoring the guest.
* **Time synchronization**. With the Guest Additions installed, Oracle VM VirtualBox can ensure that the guest's system time is better synchronized with that of the host.
* **Shared clipboard**. With the Guest Additions installed, the clipboard of the guest operating system can optionally be shared with your host operating system.
* **Automated logins**. Also called credentials passing.

Each version of Oracle VM VirtualBox, even minor releases, ship with their own version of the Guest Additions. While the interfaces through which the Oracle VM VirtualBox core communicates with the Guest Additions are kept stable so that Guest Additions already installed in a VM should continue to work when Oracle VM VirtualBox is upgraded on the host, for best results, it is recommended to keep the Guest Additions at the same version.

The Windows and Linux Guest Additions therefore check automatically whether they have to be updated. If the host is running a newer Oracle VM VirtualBox version than the Guest Additions, a notification with further instructions is displayed in the guest.

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.