# ruby-cli

**ruby-cli** is a command line tool to bootstrap a code tree of Ruby, which is released as a gem of [rubygem.org](https://rubygems.org/), and also as an executable binary built by [mruby](https://mruby.org/) using [mruby-cli](https://github.com/hone/mruby-cli).

This tool just does initial setup for such repository. Write your own code on it!

## Prerequisite

Two tools must be installed and be executable in shell.

* CRuby and [bundler](https://rubygems.org/gems/bundler)
* [mruby-cli](https://github.com/hone/mruby-cli)

## Installation

**ruby-cli** is published as executable binary. Download a binary for your system from release page, and use it.

* download ruby-cli binary from release page (not yet)

## Usage

Use `ruby-cli` command with project name to be generated.

```
$ ruby-cli myproject
$ cd myproject
$ # write your own code...
$ docker-compose run compile # for mruby-cli binary
$ rake build                 # for rubygem
```

## Release

Run these command to make tarballs for releasing this software.

```
$ rake tarball
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tagomoris/ruby-cli.

