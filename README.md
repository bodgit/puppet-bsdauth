# bsdauth

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-bsdauth.svg?branch=master)](https://travis-ci.org/bodgit/puppet-bsdauth)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-bsdauth/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-bsdauth?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/bsdauth.svg)](https://forge.puppetlabs.com/bodgit/bsdauth)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with bsdauth](#setup)
    * [What bsdauth affects](#what-bsdauth-affects)
    * [Beginning with bsdauth](#beginning-with-bsdauth)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: bsdauth](#class-bsdauth)
        * [Class: bsdauth::ldap](#class-bsdauthldap)
        * [Defined Type: bsdauth::class](#defined-type-bsdauthclass)
    * [Examples](#examples)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the BSD authentication framework primarily found on
OpenBSD.

## Module Description

This module manages the `/etc/login.conf` configuration file containing all of
the login classes and installs any packages required for additional login
styles.

## Setup

### What bsdauth affects

* Manages entries in `/etc/login.conf`.
* Optionally compiling the `/etc/login.conf.db` for faster lookups.
* Any package(s) used by additional login styles.

### Beginning with bsdauth

```puppet
include ::bsdauth
```

## Usage

### Classes and Defined Types

#### Class: `bsdauth`

**Parameters within `bsdauth`:**

##### `build_db`

Whether to compile the optional `/etc/login.conf.db` for faster lookups.

#### Class: `bsdauth::ldap`

**Parameters within `bsdauth::ldap`:**

##### `base_dn`

The base DN from which to perform all LDAP queries.

##### `servers`

An array of `ldap:///` and/or `ldaps:///` URI strings representing servers to use.

##### `bind_dn`

The Distinguished Name to use to bind to the LDAP servers.

##### `bind_pw`

The password to use when binding to the LDAP servers.

##### `group_dn`

The base DN from which to perform group LDAP queries, if different from
`base_dn`.

##### `group_filter`

The LDAP search filter to use when testing for group membership.

##### `login_class`

The login class to use, defaults to `ldap`.

##### `user_filter`

The LDAP search filter to use when searching for users, defaults to
`(&(objectclass=posixAccount)(uid=%u))`.

#### Defined Type: `bsdauth::class`

**Parameters within `bsdauth::class`:**

##### `name`

The name of the login class.

##### `capabilities`

An array of capabilities to add to the login class.

##### `order`

The order in which to place this class within the `/etc/login.conf` file. This
should be `'10'` or higher to come after the default classes.

### Examples

Set up the default classes and compile the `/etc/login.conf.db` database:

```puppet
class { '::bsdauth':
  build_db => true,
}
```

Set up the default classes and add an LDAP login class pointing at three LDAP
servers and using anonymous binds:

```puppet
include ::bsdauth

class { '::bsdauth::ldap':
  base_dn => 'dc=example,dc=com',
  servers => [
    'ldap://127.0.0.1',
    'ldap://192.0.2.1',
    'ldaps://192.0.2.2',
  ],
}
```

## Reference

### Classes

#### Public Classes

* [`bsdauth`](#class-bsdauth): Main class for configuring BSD authentication.
* [`bsdauth::ldap`](#class-bsdauthldap): Main class for configuring LDAP
  authentication.

#### Private Classes

* `bsdauth::config`: Handles BSD authentication configuration.
* `bsdauth::params`: Different configuration data for different systems.
* `bsdauth::ldap::config`: Handles LDAP login class configuration.
* `bsdauth::ldap::install`: Handles `login_ldap` package installation.

### Defined Types

#### Public Defined Types

* [`bsdauth::class`](#defined-type-bsdauthclass): Handles creating login
  classes.

## Limitations

This module has been built on and tested against Puppet 3.0 and higher.

The module has been tested on:

* OpenBSD 5.7

Testing on other platforms has been light and cannot be guaranteed.

## Development

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-bsdauth).
