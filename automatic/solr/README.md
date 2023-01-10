# ![Apache Solr](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@70dea0b/icons/solr.png "Apache Solr Logo") [Apache Solr](https://chocolatey.org/packages/solr)

Solr is a standalone enterprise search server with a REST-like API. You put documents in it (called "indexing") via JSON, XML, CSV or binary over HTTP. You query it via HTTP GET and receive JSON, XML, CSV or binary results.

## Features

- Advanced Full-Text Search Capabilities
- Optimized for High Volume Traffic
- Standards Based Open Interfaces - XML, JSON and HTTP
- Comprehensive Administration Interfaces
- Easy Monitoring
- Highly Scalable and Fault Tolerant
- Flexible and Adaptable with easy configuration
- Near Real-Time Indexing
- Extensible Plugin Architecture
- Schema when you want, schemaless when you don't
- Powerful Extensions
- Faceted Search and Filtering
- Geospatial Search
- Advanced Configurable Text Analysis
- Highly Configurable and User Extensible Caching
- Performance Optimizations
- Secure Solr with SSL, Authentication and Role based Authorization
- Advanced Storage Options (codecs, directories and more)
- Monitorable Logging
- Query Suggestions, Spelling and More
- JSON, CSV, XML and more are supported out of the box.
- Rich Document Parsing via Apache Tika
- Integrates into Apache UIMA
- Multiple search indices

See more at [features page](https://lucene.apache.org/solr/features.html)

## Package Parameters

- `/InstallDir` - Install/unpack to a custom location. Chocolatey will remove files from this custom location on uninstall but **WILL NOT** upgrade files in this custom location without using the `/InstallDir` parameter again.

## Notes

- **This software in this package _requires_ a minimum of version 11 of a Java Runtime Engine. It will not work without one.** As there are so many flavours of Java I leave it to you to choose the one your prefer. My current recommendation is [Temurin](https://community.chocolatey.org/packages/Temurinjre) if you don't already have one installed. See the [Solr Java Requirements](https://solr.apache.org/guide/solr/latest/deployment-guide/system-requirements.html#java-requirements) for more information.
- The Solr binaries are extracted to the `solr-<VERSION_NUMBER>` folder of the local tools folder (by default `c:\tools` - see [`Get-ToolsLocation`](https://docs.chocolatey.org/en-us/create/functions/get-toolslocation) for more information). This is consistent with previous versions.
- **NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.