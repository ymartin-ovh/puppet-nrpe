
class nrpe::params {

  $nrpe_provider = $::osfamily ? {
    'Solaris' => pkgutil,
    default   => undef,
  }

  case $::osfamily {
    'Debian':  {
      $libdir           = '/usr/lib/nagios/plugins'
      $nrpe_user        = 'nagios'
      $nrpe_group       = 'nagios'
      $nrpe_pid_file    = '/var/run/nagios/nrpe.pid'
      $nrpe_config      = '/etc/nagios/nrpe.cfg'
      $nrpe_include_dir = '/etc/nagios/nrpe.d/'
      $nrpe_service     = 'nagios-nrpe-server'
      $nrpe_packages    = [
        'nagios-nrpe-server',
        'nagios-plugins',
      ]
    }
    'Solaris': {
      $libdir           = '/opt/csw/libexec/nagios-plugins'
      $nrpe_user        = 'nagios'
      $nrpe_group       = 'nagios'
      $nrpe_pid_file    = '/var/run/nrpe.pid'
      $nrpe_config      = '/opt/csw/etc/nrpe.cfg'
      $nrpe_include_dir = '/opt/csw/etc/nrpe.d'
      $nrpe_service     = 'cswnrpe'
      $nrpe_packages    = [
        'nrpe',
        'nagios_plugins',
      ]
    }
    'RedHat':  {
      $libdir           = '/usr/lib64/nagios/plugins'
      $nrpe_user        = 'nrpe'
      $nrpe_group       = 'nrpe'
      $nrpe_pid_file    = '/var/run/nrpe/nrpe.pid'
      $nrpe_config      = '/etc/nagios/nrpe.cfg'
      $nrpe_include_dir = '/etc/nrpe.d'
      $nrpe_service     = 'nrpe'
      $nrpe_packages    = [
        'nrpe',
        'nagios-plugins-all',
      ]
    }
    'FreeBSD': {
    }
    'Suse':  {
    }
    default:   {
    }
  }

}
