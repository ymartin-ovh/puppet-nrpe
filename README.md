NRPE Module for Puppet
======================

This module installs and configures nrpe.

Dependencies
------------

### Redhat

 * This module requires the EPEL repositories to be enabled
 * This module currently does not manage the firewall rules

### Solaris

  * This module depends on OpenCSW packages

Usage
-----

### nrpe 

This class installs the packages and configures the daemon.

    class { 'nrpe':
        allowed_hosts => ['127.0.0.1', 'nagios.example.org']
    }


### nrpe::command

This define can be used to add nrpe commands to the include directory for nrpe

    nrpe::command {
        'check_users':
          ensure  => present,
          command => 'check_users -w 5 -c 10';
    }

To purge unmanaged nrpe commands:

    class { 'nrpe':
      allowed_hosts => ['127.0.0.1'],
      purge         => true,
      recurse       => true,
    }
