# Bearer pre-commit hooks

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://stand-with-ukraine.pp.ua)
![GitHub release](https://img.shields.io/github/v/release/fabasoad/pre-commit-bearer?include_prereleases)
![security](https://github.com/fabasoad/pre-commit-bearer/actions/workflows/security.yml/badge.svg)
![linting](https://github.com/fabasoad/pre-commit-bearer/actions/workflows/linting.yml/badge.svg)
![functional-tests](https://github.com/fabasoad/pre-commit-bearer/actions/workflows/functional-tests.yml/badge.svg)

## Table of Contents

- [Bearer pre-commit hooks](#bearer-pre-commit-hooks)
  - [Table of Contents](#table-of-contents)
  - [How it works?](#how-it-works)
  - [Prerequisites](#prerequisites)
  - [Hooks](#hooks)
    - [scan-sast](#scan-sast)
    - [scan-secrets](#scan-secrets)
  - [Customization](#customization)
    - [Description](#description)
    - [Parameters](#parameters)
      - [Bearer](#bearer)
      - [pre-commit-bearer](#pre-commit-bearer)
        - [Log level](#log-level)
        - [Log color](#log-color)
        - [Bearer version](#bearer-version)
        - [Clean cache](#clean-cache)
    - [Examples](#examples)
  - [Contributions](#contributions)

## How it works?

At first hook tries to use globally installed `bearer` tool. And if it doesn't exist
then hook installs `bearer` into a `.fabasoad/pre-commit-bearer` temporary directory
that will be removed after scanning is completed.

## Prerequisites

The following tools have to be available on a machine prior using this pre-commit
hook:

- [bash >=4.0](https://www.gnu.org/software/bash/)
- [curl](https://curl.se/)
- [jq](https://jqlang.github.io/jq/)

## Hooks

<!-- markdownlint-disable-next-line MD013 -->

> `<rev>` in the examples below, is the latest revision tag from [fabasoad/pre-commit-bearer](https://github.com/fabasoad/pre-commit-bearer/releases)
> repository.

### scan-sast

This hook runs [scan . --scanner=sast](https://docs.bearer.com/explanations/scanners/#sast-scanner)
command.

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-bearer
    rev: <rev>
    hooks:
      - id: scan-sast
```

### scan-secrets

This hook runs [scan . --scanner=secrets](https://docs.bearer.com/explanations/scanners/#secrets-scanner)
command.

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-bearer
    rev: <rev>
    hooks:
      - id: scan-secrets
```

## Customization

### Description

There are 2 ways to customize scanning for both `bearer` and `pre-commit-bearer`-
environment variables and arguments passed to [args](https://pre-commit.com/#config-args).

You can pass arguments to the hook as well as to the `bearer` itself. To distinguish
parameters you need to use `--bearer-args` for `bearer` arguments and `--hook-args`
for `pre-commit-bearer` arguments. Supported delimiter is `=`. So, use `--hook-args=<arg>`
but not `--hook-args <arg>`. Please find [Examples](#examples) for more details.

### Parameters

#### Bearer

You can [install](https://docs.bearer.com/quickstart/#installation) `bearer` locally
and run `bearer --help` to see all the available arguments:

<!-- prettier-ignore-start -->

<!-- markdownlint-disable MD013 MD010 -->

```shell
$ bearer --version
bearer version 1.51.1, build 039294eca49451fdeaa381aa2f0926f8bf3d03ea

$ bearer --help
Scan your source code to discover, filter and prioritize security and privacy risks.

Usage: bearer <command> [flags]

Available Commands:
	completion        Generate the autocompletion script for your shell
	scan              Scan a directory or file
	init              Write the default config to bearer.yml
	ignore            Manage ignored fingerprints
	version           Print the version

Examples:
	# Scan local directory or file and output security risks
	$ bearer scan <path> --scanner=sast,secrets

	# Scan current directory and output the privacy report to a file
	$ bearer scan --report privacy --output <output-path> .

	# Scan local directory and output details about the underlying
	# detections and classifications
	$ bearer scan . --report dataflow

Learn More:
	Bearer is a code security tool that scans your source code to
	identify OWASP/CWE top security risks, privacy impact, and sensitive dataflows

	For more examples, tutorials, and to learn more about the project
	visit https://docs.bearer.com
```

<!-- markdownlint-enable MD013 MD010 -->

<!-- prettier-ignore-end -->

#### pre-commit-bearer

Here is the precedence order of `pre-commit-bearer` tool:

- Parameter passed to the hook as argument via `--hook-args`.
- Environment variable.
- Default value.

For example, if you set `PRE_COMMIT_BEARER_LOG_LEVEL=warning` and `--hook-args=--log-level
error` then `error` value will be used.

##### Log level

With this parameter you can control the log level of `pre-commit-bearer` hook output.
It doesn't impact `bearer` log level output. To control `bearer` log level output
please look at the [Bearer parameters](#bearer).

- Parameter name: `--log-level`
- Environment variable: `PRE_COMMIT_BEARER_LOG_LEVEL`
- Possible values: `debug`, `info`, `warning`, `error`
- Default: `info`

##### Log color

With this parameter you can enable/disable the coloring of `pre-commit-bearer`
hook logs. It doesn't impact `bearer` logs coloring.

- Parameter name: `--log-color`
- Environment variable: `PRE_COMMIT_BEARER_LOG_COLOR`
- Possible values: `true`, `false`
- Default: `true`

##### Bearer version

Specifies specific `bearer` version to use. This will work only if `bearer` is
not globally installed, otherwise globally installed `bearer` takes precedence.

- Parameter name: `--bearer-version`
- Environment variable: `PRE_COMMIT_BEARER_BEARER_VERSION`
- Possible values: [Bearer version](https://github.com/Bearer/bearer/releases)
- Default: `latest`

##### Clean cache

With this parameter you can choose either to keep cache directory (`.fabasoad/pre-commit-bearer`),
or to remove it. By default, it removes cache directory. With `false` parameter
cache directory will not be removed which means that if `bearer` is not installed
globally every subsequent run won't download `bearer` again. Don't forget to add
cache directory into the `.gitignore` file.

- Parameter name: `--clean-cache`
- Environment variable: `PRE_COMMIT_BEARER_CLEAN_CACHE`
- Possible values: `true`, `false`
- Default: `true`

### Examples

Pass arguments separately from each other:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-bearer
    rev: <rev>
    hooks:
      - id: scan-sast
        args:
          - --hook-args=--log-level debug
          - --bearer-args=--fail-on-severity low
          - --bearer-args=--config-file bearer.yaml
```

Pass arguments altogether grouped by category:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-bearer
    rev: <rev>
    hooks:
      - id: scan-sast
        args:
          - --hook-args=--log-level debug
          - --bearer-args=--fail-on-severity low --config-file bearer.yaml
```

Set these parameters to have the minimal possible logs output:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-bearer
    rev: <rev>
    hooks:
      - id: scan-sast
        args:
          - --hook-args=--log-level=error
          - --bearer-args=--quiet --log-level error
```

## Contributions

![Alt](https://repobeats.axiom.co/api/embed/858ac0ba4dfbfa78ced1bdb84e77e8498d52ee80.svg "Repobeats analytics image")
