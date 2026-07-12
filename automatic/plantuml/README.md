# ![PlantUML](https://cdn.jsdelivr.net/gh/pauby/ChocoPackages@e79ba5a/icons/plantuml.png "PlantUML Logo") [PlantUML](https://chocolatey.org/packages/plantuml)

PlantUML is an open-source tool allowing users to create UML and other diagrams from a plain text language. Diagrams are defined using a simple and intuitive language. This can be used within many other tools. Images can be generated in PNG, in SVG or LaTeX format. It is also possible to generate ASCII art diagrams (only for sequence diagrams).

Try it online using [plantuml online server](https://www.plantuml.com/plantuml).

## Features

- [Sequence diagram](https://plantuml.com/sequence.html)
- [Use case diagram](https://plantuml.com/usecase.html)
- [Class diagram](https://plantuml.com/classes.html)
- [Activity diagram](https://plantuml.com/activity2.html)
- [Component diagram](https://plantuml.com/component.html)
- [State diagram](https://plantuml.com/state.html)
- [Object diagram](https://plantuml.com/objects.html)
- [Deployment diagram](https://plantuml.com/deployment.html)
- [Timing diagram](https://plantuml.com/timing-diagram)
- [Mindmap diagram](https://plantuml.com/mindmap-diagram)
- [Wireframe graphical interface](https://plantuml.com/salt.html)
- [Archimate diagram](https://plantuml.com/timing-diagram)
- [Specification and Description Language (SDL)](https://plantuml.com/activity-diagram-beta#sdl)
- [Ditaa diagram](https://plantuml.com/ditaa)
- [Gantt diagram](https://plantuml.com/gantt-diagram)
- [Work Breakdown Structure diagram](https://plantuml.com/wbs-diagram)
- [Mathematic with AsciiMath or JLaTeXMath notation](https://plantuml.com/ascii-math)

## Package parameters

- `/NoShortcuts` - Do not create desktop shortcuts for plantuml and its manual.

## Notes

- This package creates two shims - `plantuml` (invoked via `javaw`) and `plantumlc` (invoked via `java`). The later one should be used with scripting. See available command line options with `plantumlc -help`. For example, to convert entire directory of plantuml files to images recursivelly, you can use `plantumlc -r -tsvg **\*.puml`.
- Since version `1.2019.11.20191001`, this package depends on [AdoptOpenJDKJRE](https://chocolatey.org/packages/AdoptOpenJDKJRE) package instead of the [javaruntime](https://chocolatey.org/packages/javaruntime) that it previously used; later requires a license for commercial use since 2019.
- This is an automatically updated package. If you find it is out of date by more than a week, please contact the maintainer(s), to let the know the package is no longer updating, using:
    - The 'Contact Maintainers' link on the package page, or
    - The 'Package Source' link on the package page and raising an issue.
