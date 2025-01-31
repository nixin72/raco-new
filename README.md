# Raco new

Create new projects for Racket with the raco CLI.

# Install

Ensure that `raco` is on your path

Run the `raco` command:
```bash
raco pkg install raco-new
```

Or you can install from DrRacket by looking for `raco-new` under **File|Package Manager**

# Usage

You can find a list of all available templates using:
```bash
raco new --list
```

And create a new app with one of those templates using:
```bash
raco new <template> <project-name>
```

This will create a new directory `<project-name>` containing the templated project

# Contributing to this project

Contibutions to both this tool and the collection of templates is welcome.

Contribute to this project by submitting a pull request or reporting an issue.

Discussion on [Racket Discussions (Discourse forum/mailing list)](https://racket.discourse.group/) or [Racket Discord](https://discord.gg/6Zq8sH5).

# License

This package is free software, see [LICENSE](https://github.com/nixin72/raco-new/blob/master/LICENSE) for more details.

By making a contribution, you are agreeing that your contribution is licensed under the Apache 2.0 license and the MIT license.

## get started

```
git clone git@github:nixin72/raco-new.git
cd raco-new
raco pkg install
```
