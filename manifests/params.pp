
class nrpe::params {

  $nrpe_provider = $::osfamily ? {
    'Solaris' => pkgutil,
    default   => undef,
  }

  case $::osfamily {
    'Debian':  {
      $nrpe_pid_file    = '/var/run/nagios/nrpe.pid'
      $nrpe_config      = '/etc/nagios/nrpe.cfg'
      $nrpe_include_dir = '/etc/nagios/nrpe.d/'
      $nrpe_service     = 'nagios-nrpe-server'
      $nrpe_packages    = [
        'nagios-nrpe-server',
        'nagios-nrpe-plugin',
      ]
    }
    'Solaris': {
      $nrpe_pid_file    = '/var/run/nrpe.pid'
      $nrpe_config      = '/opt/csw/etc/nrpe.cfg'
      $nrpe_include_dir = '/opt/csw/etc/nrpe.d'
      $nrpe_service     = 'cswnrpe'
      $nrpe_packages    = [
        'nrpe',
        'nrpe_plugin'
      ]
    }
    'RedHat':  {
    }
    'FreeBSD': {
    }
    'Suse':  {
    }
    default:   {
    }
  }

}
