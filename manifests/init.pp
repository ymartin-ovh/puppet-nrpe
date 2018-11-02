# @summary Installs and configures NRPE
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
  Array[String[1]]                     $supplementary_groups            = [],
) inherits nrpe::params {

  # Extra validation
  if $ssl_cert_file_content {
    assert_type(String[1], $ssl_privatekey_file_content)
    assert_type(String[1], $ssl_cacert_file_content)
  }

  contain nrpe::install
  contain nrpe::config
  contain nrpe::service

  Class['nrpe::install']
  -> Class['nrpe::config']
  ~> Class['nrpe::service']

  Class['nrpe::install'] -> Nrpe::Plugin <||>
  Class['nrpe::install'] -> Nrpe::Command <||> ~> Class['nrpe::service']
}
