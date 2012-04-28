---
# +++ OpenZoom is no longer being maintained nor supported +++
---

      ____              ____
     / __ \___  ___ ___/_  / ___  ___  __ _
    / /_/ / _ \/ -_) _ \/ /_/ _ \/ _ \/  ' \
    \____/ .__/\__/_//_/___/\___/\___/_/_/_/
        /_/

# OpenZoom
### Open Source Toolkit For Multiscale Images and Zoomable User Interfaces (ZUIs)

Copyright © 2007–2012, [Daniel Gasienica](daniel@gasienica.ch). All rights reserved.

- [Website](http://openzoom.org/)
- Follow [@OpenZoom](http://twitter.com/OpenZoom) on Twitter
- [Download code](http://openzoom.org/go/code)


#  Welcome

Welcome to the OpenZoom SDK project.

The OpenZoom SDK and examples can easily be imported into Eclipse through
the `Import...` command. First, please set the Eclipse `OPENZOOM_HOME`
linked resource to point the master branch of the OpenZoom SDK project
and get started!

## Instructions: `OPENZOOM_HOME` Linked Resource (Eclipse)

*Eclipse > Preferences > General > Workspace > Linked Resources > New...*

**Name:** `OPENZOOM_HOME`<br/>
**Location:** ... (e.g. /Users/dani/workspace/openzoom/sdk/)


#  Prerequisites

The OpenZoom SDK has been tested with Flex Builder 4 and the Flex SDK 3.6

#  Building

To customize your build, please create a copy of `build.properties` and rename
it to `local.properties`. Then, run the command

    ant

for creating the `openzoom.swc` SWC in the `bin` folder or run

    ant doc

for creating the OpenZoom SDK API documentation in the docs folder.

#  License

Before using the OpenZoom SDK, please carefully read the licensing terms
in `LICENSE.txt` and consult with a lawyer if you have any questions.


### Epilogue

Have fun with the OpenZoom SDK and create something awesome.
Share your ideas, issues and work you've done on the [OpenZoom Community](http://openzoom.org/go/community)
Please file bug reports on our [issue tracker](http://github.com/openzoom/sdk/issues).
I am looking forward to see what you create with OpenZoom.

Yours,
Daniel
