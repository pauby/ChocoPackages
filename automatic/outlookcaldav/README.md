# ![Outlook CalDav Synchronizer](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@ea075a55/icons/outlookcaldav.png "Outlook CalDav Synchronizer Logo") [Outlook CalDav Synchronizer](https://chocolatey.org/packages/outlookcaldav)

Outlook Plugin, which synchronizes events, tasks and contacts between Outlook and Google, SOGo, Horde or any other CalDAV or CardDAV server. Supported Outlook versions are 2016, 2013, 2010 and 2007.

## Tested CalDAV Servers

Baïkal - Cozy Cloud - cPanel - Cyrus Imap 2.5 - DAViCal - EGroupware - FastMail - Fruux - GMX - Google Calendar - Group-Office - Horde Kronolith - iCloud - Kolab - Landmarks - Mac OS X Server - mail.ru - mailbox.org - Nextcloud - One.com - Open-Xchange - Owncloud - Posteo - Radicale - SabreDAV - SmarterMail - SOGo - Synology DSM - Tine 2.0 - Yahoo - Yandex - Zimbra 8.5 - Zoho Calendar

## Features

- open source AGPL, the only free Outlook CalDav plugin
- two-way-sync
- Localization support
- SSL/TLS support, support for self-signed certificates and client certificate authentication
- Manual proxy configuration support for NTLM or basic auth proxies
- Autodiscovery of calendars and addressbooks
- configurable sync range
- sync multiple calendars per profile
- sync reminders, categories, recurrences with exceptions, importance, transparency
- sync organizer and attendees and own response status
- task support
- Google native Contacts API support with mapping of Google contact groups to Outlook categories.
- Google Tasklists support (sync via Google Task Api with Outlook task folders)
- CardDAV support to sync contacts (distribution lists planned)
- Map Outlook Distribution Lists to contacts groups in SOGo VLIST, KIND:GROUP or iCloud group format
- time-triggered-sync
- change-triggered-sync
- manual-triggered-sync
- Support for WebDAV Collection Sync (RFC 6578)
- Category Filtering (sync CalDAV calendar/tasks to Outlook categories)
- map CalDAV server colors to Outlook category colors
- show reports of last sync runs and status
- System TrayIcon with notifications
- bulk creation of multiple profiles
- Use server settings from Outlook IMAP/POP3 account profile
- Map Windows to standard IANA/Olson timezones
- Configurable mapping of Outlook custom properties
- create DAV server calendars/addressbooks with MKCOL
- Map Outlook formatted RTFBody to html description via X-ALT-DESC attribute
- Support for RFC7986 per-event color handling, mapping of Outlook category color to COLOR attribute

Please see the full list on the [project README](https://github.com/aluxnimm/outlookcaldavsynchronizer/blob/master/README.md).

## Package Parameters

You can pass the following parameters:

- Install for all users not just the current user: `/allusers`

Example:

`--params '"/allusers"'`

## Notes

- This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.