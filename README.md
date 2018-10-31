# NRPE Module for Puppet

[![License](https://img.shields.io/github/license/voxpupuli/puppet-nrpe.svg)](https://github.com/voxpupuli/puppet-nrpe/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-nrpe.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-nrpe)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/nrpe.svg)](https://forge.puppetlabs.com/puppet/nrpe)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/nrpe.svg)](https://forge.puppetlabs.com/puppet/nrpe)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/nrpe.svg)](https://forge.puppetlabs.com/puppet/nrpe)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with this module](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module Description

NRPE (Nagios Remote Plugin Executor) allows you to remotely execute Nagios plugins on other Linux/Unix machines. This allows you to monitor remote machine metrics (disk usage, CPU load, etc.).
This puppet module manages the instllation and configuration of NRPE.  It can install NRPE plugins and setup NRPE commands.  Secure communication to NRPE using SSL is also supported.

## Setup

The `nrpe` class installs the packages and configures the daemon.  By default, it will only configure the daemon to listen on localhost.
To allow connections from your nagios server, specify the `allowed_hosts` parameter when declaring the class.

```puppet
class { 'nrpe':
  allowed_hosts => ['127.0.0.1', 'nagios.example.org'],
}
```

## Usage

### nrpe

No NRPE commands are configured by default. To make the configuration useful, at a minimum, declare some [`nrpe::command`](#nrpecommand) resources.
To purge unmanaged nrpe commands:

```puppet
class { 'nrpe':
  allowed_hosts => ['127.0.0.1'],
  purge         => true,
  recurse       => true,
}
```

### nrpe::command

This define can be used to add nrpe commands to the include directory for nrpe

```puppet
nrpe::command { 'check_users':
  ensure  => present,
  command => 'check_users -w 5 -c 10';
}
```

### nrpe::plugin

This define can be used to install nrpe plugins

```puppet
nrpe::plugin { 'check_mem':
  ensure => present,
  source => 'puppet:///files/check_mem',
}
```

## Limitations

### Redhat

 * This module requires the EPEL repositories to be enabled
 * This module currently does not manage the firewall rules

### Solaris

 * This module depends on OpenCSW packages

## Development

Improvements and bug fixes are greatly appreciated.

This module is a fork of [pdxcat/nrpe](https://forge.puppet.com/pdxcat/nrpe)

It is licensed under the Apache License, Version 2.0.
