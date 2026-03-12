---
name: cardano-search
description: |
  Search through the Cardano repositories in this directory. Use when looking
  through the local Cardano repositories for implementations and reference
  code, and when asked about how to do things with Cardano or Ouroboros.
allowed-tools: Read, Grep, Glob
---

All the repositories in the [repos](repos) directory are Haskell repositories
pertaining to the Cardano and Ouroboros ecosystem of Haskell packages. Most, if
not all, of them are multi-package repositories. Each package has
a corresponding `<name>.cabal` file that describes the package, including
pointing to where the source code is. Each `<name>.cabal` file specified one or
more libraries for applications or testing.

When referencing code and implementations from these repositories, always
include the path to the file in question relative to the current working
directory, as well as the line number(s), of the referenced code.
