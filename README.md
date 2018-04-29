# bsdauth

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-bsdauth.svg?branch=master)](https://travis-ci.org/bodgit/puppet-bsdauth)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-bsdauth/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-bsdauth?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/bsdauth.svg)](https://forge.puppetlabs.com/bodgit/bsdauth)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-bsdauth.svg)](https://gemnasium.com/bodgit/puppet-bsdauth)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with bsdauth](#setup)
    * [Beginning with bsdauth](#beginning-with-bsdauth)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module manages the BSD authentication framework primarily found on
OpenBSD. It manages the `/etc/login.conf` configuration file containing all
of the login classes and installs any packages required for additional login
styles.

OpenBSD is supported using Puppet 4.4.0 or later.

## Setup

### Beginning with bsdauth

To maintain the default `/etc/login.conf` content and login classes, use the
following:

```puppet
include ::bsdauth
include ::bsdauth::authpf
include ::bsdauth::bgpd
include ::bsdauth::pbuild
include ::bsdauth::unbound
```

## Usage

To override the default login classes, (you then must manage all of them):

```puppet
class { '::bsdauth':
  classes => {
    'auth-defaults' => {
      'capabilities' => [
        'auth=yubikey,passwd',
      ],
      'order'        => '01',
    },
    ...
  },
}
```

To add an additional login class:

```puppet
include ::bsdauth
::bsdauth::class { 'example':
  capabilities => [
    'auth=yubikey,passwd',
    'tc=default',
  ],
}
```

To enable LDAP login support:

```puppet
include ::bsdauth
include ::bsdauth::ldap
::bsdauth::ldap::class { 'ldap':
  base_dn => 'dc=example,dc=com',
  servers => [
    {
      'hostname' => '192.0.2.1',
    },
  ],
}
```

## Reference

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-bsdauth/](https://bodgit.github.io/puppet-bsdauth/).

## Limitations

This module has been built on and tested against Puppet 4.4.0 and higher.

The module has been tested on:

* OpenBSD 6.2/6.3

## Development

The module has both [rspec-puppet](http://rspec-puppet.com) and
[beaker-rspec](https://github.com/puppetlabs/beaker-rspec) tests. Run them
with:

```
$ bundle exec rake test
$ PUPPET_INSTALL_TYPE=agent PUPPET_INSTALL_VERSION=x.y.z bundle exec rake beaker:<nodeset>
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-bsdauth).
