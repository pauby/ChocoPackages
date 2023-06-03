# [Microsoft VCLibs](https://chocolatey.org/packages/microsoft-vclibs)

Windows desktop applications that have a dependency on the C++ Runtime libraries must specify the corresponding version of the C++ Runtime framework package for Desktop Bridge during creation of the application package. This must be done instead of just redistributing the C++ Runtime libraries that are included with Visual Studio or the Visual C++ Runtime redistributable (VCRedist).

Windows desktop applications that run in a Desktop Bridge container cannot use the C++ Runtime libraries that are included with Visual Studio or VCRedist. An application that's running in a Desktop Bridge container and that uses an incorrect version of the C++ runtime libraries might fail when it tries to access resources such as the file system or the registry. This article discusses how to create a Desktop Bridge container that includes the correct C++ Runtime libraries.

**NOTE**: This is a manually updated package.
