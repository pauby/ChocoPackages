# ![Create A Chocolatey Repository Under Nexus](https://rawcdn.githack.com/pauby/ChocoPackages/53d087737359e5b19588374db7bbdd1c6ac42829/icons/nexus-choco-repo.png "Nexus Logo") [Create A Chocolatey Repository Under Nexus](https://chocolatey.org/packages/nexus-choco-repo)

Creates a NuGet repository under Nexus for use with Chocolatey.

You can pass the following parameters:

* `/ServerUri`      - The Uri of your Nexus server. Defaults to `https://localhost:8081` (e.g. `--params="'/ServerUri=http://localhost:8081'"`);
* `/Username`       - [Required] Username with permissions to create repositories and add the NuGet Realm on your Nexus server (e.g. `--params="'/Username=admin'"`);
* `/Password`       - [Required] Password for the username parameter (e.g. `--params="'/Username=admin /Password=abc'"`);
* `/RepositoryName` - The name to use for the created repository. Defaults to `choco-base` (e.g. `--params="'/RepositoryName=my-repo'"`);
* `/BlobStoreName`  - Name of the blob store to create the repository on. Defaults to `default`. (e.g. `--params="'/BlobStoreName=myblob'"`);

NOTE: Uninstalling this package does not remove the repository created or disable the NuGet Realm in Nexus. This must be done manually.