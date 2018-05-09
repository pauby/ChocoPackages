# ![MySQL Connector Logo](https://cdn.rawgit.com/pauby/ChocoPackages/04a071d0/icons/mysql-connector.png "MySQL Connector Logo") [MySQL Connector](https://chocolatey.org/packages/mysql-connector)

MySQL Connector/Net enables you to develop .NET applications that require secure, high-performance data connectivity with MySQL. It implements the required ADO.NET interfaces and integrates into ADO.NET-aware tools. You can build applications using your choice of .NET languages. Connector/Net is a fully managed ADO.NET data provider written in 100% pure C#. It does not use the MySQL C client library.

For notes detailing the changes in each release of Connector/Net, see MySQL Connector/Net Release Notes.

MySQL Connector/Net includes full support for:

* Features provided by MySQL Server up to and including MySQL Server 8.0.

* Large-packet support for sending and receiving rows and BLOB values up to 2 gigabytes in size.

* Protocol compression, which enables compressing the data stream between the client and server.

* Connections using TCP/IP sockets, named pipes, or shared memory on Windows.

* Connections using TCP/IP sockets or Unix sockets on Unix.

* The Open Source Mono framework developed by Novell.

* Entity Framework.

* .NET for Windows 8.x Store apps (Windows RT Store apps). 

This document is intended to be a developer guide for MySQL Connector/Net and includes a full syntax reference. Syntax information is also included within the ConnectorNET.chm file included with the Connector/Net distribution.

If you are using MySQL 5.0 or later, and Visual Studio as your development environment, you can also use the MySQL Visual Studio Plugin. The plugin acts as a DDEX (Data Designer Extensibility) provider: you can use the data design tools within Visual Studio to manipulate the schema and objects within a MySQL database. For more information see MySQL for Visual Studio.

MySQL Connector/Net supports full versions of Visual Studio 2008, 2010, 2012, 2013, 2015, and 2017, although the extent of support may be limited depending on your versions of MySQL Connector/Net and Visual Studio. For details, see MySQL for Visual Studio.

MySQL Connector/Net 6.8 (and earlier) does not support Express versions of Microsoft products, including Microsoft Visual Web Developer. MySQL Connector/Net 6.9, 6.10, and 7.0 do provide support for these products. 

## Note

From Connector/Net 5.1 through 6.6, the Visual Studio Plugin is part of the main Connector/Net package. Starting with 6.7, the Visual Studio Plugin has been separated out and renamed to MySQL for Visual Studio. For release information, see MySQL for Visual Studio Release Notes.

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.