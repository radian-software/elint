## Deprecated

`elint` has been deprecated. Instead of using it directly, Elisp
projects such as [`straight.el`][straight.el], [el-patch],
[`prescient.el`][prescient.el], and [diary-manager] maintain their own
build tooling.

The remainder of this README is included for historical value only.

## Usage

First, obtain the `elint` binary. The recommended way to do this is to
add this repository as a submodule into your project. Then, you may
invoke one or more tasks as follows:

    $ path/to/elint <task>...

But first, you have to define your tasks. You do this by creating a
`checkers` directory, and placing a file called `dispatch` inside it.
The `dispatch` file is a `bash` script that is executed by `elint` to
define your tasks. Here is an example:

    task longlines *.md checkers/* checkers-self/* elint elint-file
    task shellcheck elint elint-file
    task shellcheck-bash checkers/*
    task toc README.md

There are two functions you can call here, `task` and `custom_task`.
The syntax is as follows:

    task <name> <glob>...
    custom_task <name> <checker> <glob>...

The difference is that with `task`, your task will default to running
a checker of the same name as the task, whereas `custom_task` allows
you to specify a task that runs any checker.

Don't worry about word splitting: it's disabled by `elint` while
loading the `dispatch` file.

You can get started right away like this, since `elint` comes with a
few checkers already defined: for example, `checkdoc`, `compile`,
`shellcheck`, and `toc`. These checkers are all defined in the
`checkers` directory of this repository.

But you can also define your own checkers, by placing additional files
in your own `checkers` directory. A checker is a `bash` script sourced
by `elint`; it is passed a filename as a single argument (one of the
filenames defined by the task). If it produces any output, on either
stdout or stderr, that means the check failed. The output will be
reported by `elint` in a dedicated section. For example, in the
`checkers-self` directory of this repository, you can see that `elint`
defines a custom checker `shellcheck-bash` for itself.

Speaking of `checkers-self`, this is actually the `checkers` directory
that `elint` defines for itself. Normally, this directory would have
to be called `checkers`, but there is an option to call it something
else (which is what `elint` has to do, since it already has a
`checkers` directory). Just create a `.elintrc` file in the directory
from which you invoke `elint`. That file is a `bash` script that is
sourced when `elint` starts up, and it allows you to set some
environment variables. Here is an example `.elintrc`, which is used by
`elint` itself:

    ELINT_CHECKERS_DIR=checkers-self

Generally speaking it is convenient to invoke `elint` using `make`.
This way, you don't have to worry about your working directory, and
you can also define convenient grouping of tasks (for example, a group
of all tasks, or a group of tasks to be run on your CI server). Here
is an example `Makefile`:

    .PHONY: all
    all:
        @./elint longlines shellcheck toc

    .PHONY: travis
    travis:
        @./elint longlines shellcheck

    .PHONY: longlines
    longlines:
        @./elint longlines

    .PHONY: shellcheck
    shellcheck:
        @./elint shellcheck shellcheck-bash

    .PHONY: toc
    toc:
        @./elint toc
