$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-NuspecInfo($NuspecTagRequest){

# Import package.nuspec file to get values
$nuspecXML = "$env:ChocolateyInstall\lib\$env:chocolateyPackageName\$env:chocolateyPackageName.nuspec"
[xml]$nuspecFile = Get-Content $nuspecXML
$NuspecAuthors = $nuspecFile.package.metadata.authors
$NuspecBugTrackerURL = $nuspecFile.package.metadata.bugtrackerurl
$NuspecConflicts = $nuspecFile.package.metadata.conflicts # Built for the future
$NuspecCopyright = $nuspecFile.package.metadata.copyright
$NuspecDependencies = $nuspecFile.package.metadata.dependencies # Not fully implemented yet
$NuspecDescription = $nuspecFile.package.metadata.description
$NuspecDocsURL = $nuspecFile.package.metadata.docsurl
$NuspecFiles = $nuspecFile.package.files.file # Not fully implemented yet
$NuspecIconURL = $nuspecFile.package.metadata.iconurl
$NuspecID = $nuspecFile.package.metadata.id
$NuspecLicenseURL = $nuspecFile.package.metadata.licenseurl
$NuspecMailingListURL = $nuspecFile.package.metadata.mailinglisturl
$NuspecOwners = $nuspecFile.package.metadata.owners
$NuspecPackageSourceURL = $nuspecFile.package.metadata.packagesourceurl
$NuspecProjectSourceURL = $nuspecFile.package.metadata.projectsourceurl
$NuspecProjectURL = $nuspecFile.package.metadata.projecturl
$NuspecProvides = $nuspecFile.package.metadata.provides # Built for the future
$NuspecReleaseNotes = $nuspecFile.package.metadata.releasenotes
$NuspecReplaces = $nuspecFile.package.metadata.replaces # Built for the future
$NuspecRequireLicenseAcceptance = $nuspecFile.package.metadata.requirelicenseacceptance
$NuspecSummary = $nuspecFile.package.metadata.summary
$NuspecTags = $nuspecFile.package.metadata.tags
$NuspecTitle = $nuspecFile.package.metadata.title
$NuspecVersion = $nuspecFile.package.metadata.version

If ($NuspecTagRequest -eq "authors") {return $NuspecAuthors}
If ($NuspecTagRequest -eq "bugtrackerurl") {return $NuspecBugTrackerURL}
If ($NuspecTagRequest -eq "conflicts") {return $NuspecConflicts}
If ($NuspecTagRequest -eq "copyright") {return $NuspecCopyright}
If ($NuspecTagRequest -eq "dependencies") {return $NuspecDependencies} # Not fully implemented yet
If ($NuspecTagRequest -eq "description") {return $NuspecDescription}
If ($NuspecTagRequest -eq "docsurl") {return $NuspecDocsURL}
If ($NuspecTagRequest -eq "files") {return $NuspecFiles} # Not fully implemented yet
If ($NuspecTagRequest -eq "iconurl") {return $NuspecIconURL}
If ($NuspecTagRequest -eq "id") {return $NuspecID}
If ($NuspecTagRequest -eq "licenseurl") {return $NuspecLicenseURL}
If ($NuspecTagRequest -eq "mailinglisturl") {return $NuspecMailingListURL}
If ($NuspecTagRequest -eq "owners") {return $NuspecOwners}
If ($NuspecTagRequest -eq "packagesourceurl") {return $NuspecPackageSourceURL}
If ($NuspecTagRequest -eq "projectsourceurl") {return $NuspecProjectSourceURL}
If ($NuspecTagRequest -eq "projecturl") {return $NuspecProjectURL}
If ($NuspecTagRequest -eq "provides") {return $NuspecProvides}
If ($NuspecTagRequest -eq "releasenotes") {return $NuspecReleaseNotes}
If ($NuspecTagRequest -eq "replaces") {return $NuspecReplaces}
If ($NuspecTagRequest -eq "requirelicenseacceptance") {return $NuspecRequireLicenseAcceptance}
If ($NuspecTagRequest -eq "summary") {return $NuspecSummary}
If ($NuspecTagRequest -eq "tags") {return $NuspecTags}
If ($NuspecTagRequest -eq "title") {return $NuspecTitle}
If ($NuspecTagRequest -eq "version") {return $NuspecVersion}

}
