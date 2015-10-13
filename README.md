# liquibase

Newest liquibase puppet module, rewrittent to be cleaner... and shared with others

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with liquibase](#setup)
    * [What liquibase affects](#what-liquibase-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with liquibase](#beginning-with-liquibase)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module installs and makes basic configs for liquibase.

##Module Description

[Liquibase](http://www.liquibase.org/index.html), is an open source database-independent library for tracking, managing and applying database schema changes.

This module is in charge of installing a given version of liquibase tool and jdbc drivers to connect to main databases. If a version of liquibase (newer or former) is already installed, it will be removed by the module.

## Usage

## Reference

Classes :
* [Staging](#class-firewall)

###Class: staging

Manages staging directory, along with download/extraction of compressed files.
https://forge.puppetlabs.com/nanliu/staging

## Limitations

None

## Development

If you would like to contribute to this project, you can :
* Fork it
* Create new Pull Request
* Create issue

## Release Notes/Contributors/Etc
