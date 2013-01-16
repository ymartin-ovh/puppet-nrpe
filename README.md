NRPE Module for Puppet
======================

This module installs and configures nrpe.

Usage
-----

    class { 'nrpe':
        allowed_hosts => ['127.0.0.1', '10.208.8.8']
    }

    nrpe::command {
        'check_users':
          ensure  => present,
          command => 'check_users -w 5 -c 10';
    }

