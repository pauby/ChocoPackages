# ![PlatyPS Logo](https://cdn.rawgit.com/pauby/ChocoPackages/ba1ed8c9/icons/platyps.png "PlatyPS")[PlatyPS](https://chocolatey.org/packages/platyps)

PlatyPS provides a way to:

* Write PowerShell External Help in Markdown
* Generate markdown help (example) for your existing modules
* Keep markdown help up-to-date with your code

Markdown help docs can be generated from old external help files (also known as MAML-xml help), the command objects (reflection), or both.

PlatyPS can also generate cab files for Update-Help.

### Why?

Traditionally PowerShell external help files have been authored by hand or using complex tool chains and rendered as MAML XML for use as console help. MAML is cumbersome to edit by hand, and common tools and editors don't support it for complex scenarios like they do with Markdown. PlatyPS is provided as a solution for allow documenting PowerShell help in any editor or tool that supports Markdown.

An additional challenge PlatyPS tackles, is to handle PowerShell documentation for complex scenarios (e.g. very large, closed source, and/or C#/binary modules) where it may be desirable to have documentation abstracted away from the codebase. PlatyPS does not need source access to generate documentation.

Markdown is designed to be human-readable, without rendering. This makes writing and editing easy and efficient. Many editors support it (Visual Studio Code, Sublime Text, etc), and many tools and collaboration platforms (GitHub, Visual Studio Online) render the Markdown nicely.

**NOTE**: This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s) and let them know the package is no longer updating correctly.
