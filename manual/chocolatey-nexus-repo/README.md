# ![Create A Chocolatey Repository Under Nexus](https://rawcdn.githack.com/pauby/ChocoPackages/0eee89ce0a577b6d780c24f7c4cd2de52177e34b/icons/chocolatey-nexus-repo.png "Nexus Logo") [Create A Chocolatey Repository Under Nexus](https://chocolatey.org/packages/chocolatey-nexus-repo)

Creates a NuGet repository under Nexus 3 for use with Chocolatey. Note that Nexus 3 **MUST** already be installed _somewhere_. The package does not take a dependency on Nexus 3 to allow you to have it installed elsewhere in your environment. If it is not installed, please install the Chocolatey package `nexus-repository`.

You can pass the following parameters:

* `/ServerUri`      - The Uri of your Nexus server. Defaults to `https://localhost:8081` (e.g. `--params="'/ServerUri=http://localhost:8081'"`);
* `/Username`       - [Required] Username with permissions to create repositories and add the NuGet Realm on your Nexus server (e.g. `--params="'/Username=admin'"`);
* `/Password`       - [Required] Password for the username parameter (e.g. `--params="'/Username=admin /Password=abc'"`);
* `/RepositoryName` - The name to use for the created repository. Defaults to `choco-base` (e.g. `--params="'/RepositoryName=my-repo'"`);
* `/BlobStoreName`  - Name of the blob store to create the repository on. Defaults to `default`. (e.g. `--params="'/BlobStoreName=myblob'"`);

NOTE: Uninstalling this package does not remove the repository created or disable the NuGet Realm in Nexus. This must be done manually.