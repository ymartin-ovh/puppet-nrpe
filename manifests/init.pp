# == Class: nrpe
#
# Full description of class nrpe here.
#
# === Parameters
#
# Document parameters here.
#
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# === Examples
#
#
# === Copyright
#
# Copyright 2013 Computer Action Team, unless otherwise noted.
#
class nrpe (
  Array[Stdlib::Host]                  $allowed_hosts                   = ['127.0.0.1'],
  Stdlib::IP::Address                  $server_address                  = '0.0.0.0',
  Integer[0]                           $command_timeout                 = 60,
  Stdlib::Absolutepath                 $config                          = $nrpe::params::nrpe_config,
  Stdlib::Absolutepath                 $include_dir                     = $nrpe::params::nrpe_include_dir,
  Variant[String[1], Array[String[1]]] $package_name                    = $nrpe::params::nrpe_packages,
  Optional[String[1]]                  $provider                        = $nrpe::params::nrpe_provider,
  Boolean                              $manage_package                  = true,
  Optional[Boolean]                    $purge                           = undef,
  Optional[Boolean]                    $recurse                         = undef,
  String[1]                            $service_name                    = $nrpe::params::nrpe_service,
  Boolean                              $dont_blame_nrpe                 = $nrpe::params::dont_blame_nrpe,
  Nrpe::Syslogfacility                 $log_facility                    = $nrpe::params::log_facility,
  Stdlib::Port                         $server_port                     = $nrpe::params::server_port,
  Optional[Stdlib::Absolutepath]       $command_prefix                  = $nrpe::params::command_prefix,
  Boolean                              $debug                           = $nrpe::params::debug,
  Integer[0]                           $connection_timeout              = $nrpe::params::connection_timeout,
  Optional[Boolean]                    $allow_bash_command_substitution = $nrpe::params::allow_bash_command_substitution,
  String[1]                            $nrpe_user                       = $nrpe::params::nrpe_user,
  String[1]                            $nrpe_group                      = $nrpe::params::nrpe_group,
  Stdlib::Absolutepath                 $nrpe_pid_file                   = $nrpe::params::nrpe_pid_file,
  Stdlib::Absolutepath                 $nrpe_ssl_dir                    = $nrpe::params::nrpe_ssl_dir,
  Optional[String[1]]                  $ssl_cert_file_content           = undef,
  Optional[String[1]]                  $ssl_privatekey_file_content     = undef,
  Optional[String[1]]                  $ssl_cacert_file_content         = undef,
  Nrpe::Sslversion                     $ssl_version                     = $nrpe::params::ssl_version,
  Array[String[1]]                     $ssl_ciphers                     = $nrpe::params::ssl_ciphers,
  Enum['no','ask','require']           $ssl_client_certs                = $nrpe::params::ssl_client_certs,
  Boolean                              $ssl_log_startup_params          = false,
  Boolean                              $ssl_log_remote_ip               = false,
  Boolean                              $ssl_log_protocol_version        = false,
  Boolean                              $ssl_log_cipher                  = false,
  Boolean                              $ssl_log_client_cert             = false,
  Boolean                              $ssl_log_client_cert_details     = false,
  Stdlib::Filemode                     $command_file_default_mode       = '0644',
) inherits nrpe::params {

  if $manage_package {
    package { $package_name:
      ensure   => installed,
      provider => $provider,
      before   => [
        Service[$service_name],
        File['nrpe_include_dir'],
        Concat[$config],
      ],
    }
  }

  service { $service_name:
    ensure    => running,
    name      => $service_name,
    enable    => true,
    subscribe => Concat[$config],
  }

  concat { $config:
    ensure  => present,
  }

  $_allow_bash_command_substitution = $allow_bash_command_substitution ? {
    undef   => undef,
    default => bool2str($allow_bash_command_substitution, '1', '0'),
  }

  concat::fragment { 'nrpe main config':
    target  => $config,
    content => epp(
      'nrpe/nrpe.cfg.epp',
      {
        'log_facility'                    => $log_facility,
        'nrpe_pid_file'                   => $nrpe_pid_file,
        'server_port'                     => $server_port,
        'server_address'                  => $server_address,
        'nrpe_user'                       => $nrpe_user,
        'nrpe_group'                      => $nrpe_group,
        'allowed_hosts'                   => $allowed_hosts,
        'dont_blame_nrpe'                 => bool2str($dont_blame_nrpe, '1', '0'),
        'allow_bash_command_substitution' => $_allow_bash_command_substitution,
        'libdir'                          => $nrpe::params::libdir,
        'command_prefix'                  => $command_prefix,
        'debug'                           => bool2str($debug, '1', '0'),
        'command_timeout'                 => $command_timeout,
        'connection_timeout'              => $connection_timeout,
      }
    ),
    order   => '01',
  }

  if $ssl_cert_file_content {

    $_ssl_client_certs = $ssl_client_certs ? {
      'ask'     => '1',
      'require' => '2',
      default   => '0', # $ssl_client_certs = 'no'
    }

    concat::fragment { 'nrpe ssl fragment':
      target  => $config,
      content => epp(
        'nrpe/nrpe.cfg-ssl.epp',
        {
          'ssl_version'      => $ssl_version,
          'ssl_ciphers'      => $ssl_ciphers,
          'nrpe_ssl_dir'     => $nrpe_ssl_dir,
          'ssl_client_certs' => $_ssl_client_certs,
          'ssl_logging'      => nrpe::ssl_logging(
            $ssl_log_startup_params,
            $ssl_log_remote_ip,
            $ssl_log_protocol_version,
            $ssl_log_cipher,
            $ssl_log_client_cert,
            $ssl_log_client_cert_details
          )
        }
      ),
      order   =>  '02',
    }

    file { $nrpe_ssl_dir:
      ensure => directory,
      owner  => 'root',
      group  => $nrpe_group,
      mode   => '0750',
    }
    file { "${nrpe_ssl_dir}/ca-cert.pem":
      ensure  => file,
      owner   => 'root',
      group   => $nrpe_group,
      mode    => '0640',
      content => $ssl_cacert_file_content,
      notify  => Service[$service_name],
    }
    file { "${nrpe_ssl_dir}/nrpe-cert.pem":
      ensure  => file,
      owner   => 'root',
      group   => $nrpe_group,
      mode    => '0640',
      content => $ssl_cert_file_content,
      notify  => Service[$service_name],
    }
    file { "${nrpe_ssl_dir}/nrpe-key.pem":
      ensure  => file,
      owner   => 'root',
      group   => $nrpe_group,
      mode    => '0640',
      content => $ssl_privatekey_file_content,
      notify  => Service[$service_name],
    }
  }

  concat::fragment { 'nrpe includedir':
    target  => $config,
    content => "include_dir=${include_dir}\n",
    order   => '99',
  }

  file { 'nrpe_include_dir':
    ensure  => directory,
    name    => $include_dir,
    purge   => $purge,
    recurse => $recurse,
  }

}
