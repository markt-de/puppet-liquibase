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

This module is in charge of installing a given version of liquibase tool and jdbc drivers to connect to main databases. If a version of liquibase (newer or former) is already installed, it will be removed by the module.

## Setup requirements

We configure this module to download files in a staging folder.
We assume that the staging path is define before puppet-liquibase module is called.
If you don't redefine staging path, default path will be the one set in the staging module => /opt/staging

This path can be set with :
- hiera using staging::path parameter
- or
  class { 'staging':
    path  => 'your_staging_path',
  }

## Reference

Classes :
* [Staging](#class-staging)

###Class: staging

Manages staging directory, along with download/extraction of compressed files.
https://forge.puppetlabs.com/nanliu/staging

## Limitations

None

## Development

If you would like to contribute to this project, you can :
* Fork it
* Create new Pull Request
* [Create issue](https://github.com/DSI-Ville-Noumea/puppet-liquibase/issues)
