# liquibase

[![Build Status](https://travis-ci.org/DSI-Ville-Noumea/puppet-liquibase.svg?branch=master)](https://travis-ci.org/DSI-Ville-Noumea/puppet-liquibase)

Liquibase puppet module.

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet-liquibase](#setup)
    * [Setup requirements](#setup-requirements)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module installs and makes basic configs for liquibase.

##Module Description

[Liquibase](http://www.liquibase.org/index.html), is an open source database-independent library for tracking, managing and applying database schema changes.

This module is in charge of installing a given version of liquibase tool, percona-plugin and jdbc mysql drivers to connect to main databases. If a version of liquibase (newer or former) is already installed, it will be removed by the module.

## Setup requirements

- archive Class
- JDK is needed

If you don't redefine staging path, default path will be the one set in the staging module => /opt/apps

This path can be set with :
- hiera using liquibase::install\_root

## Reference

Classes :
* [Archive](#class-archive)

###Class: archive

Compressed archive file download and extraction with native types/providers for Windows and Unix
https://forge.puppet.com/modules/puppet/archive

## Limitations

None

## Development

If you would like to contribute to this project, you can :
* Fork it
* Create new Pull Request
* [Create issue](https://github.com/markt-de/puppet-liquibase/issues)
