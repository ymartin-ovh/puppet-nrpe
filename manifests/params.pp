
class nrpe::params {

  $nrpe_provider = $::osfamily ? {
    'Solaris' => pkgutil,
    default   => undef,
  }

  case $::osfamily {
    'Debian':  {
      $nrpe_user        = 'nagios'
      $nrpe_group       = 'nagios'
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
      $nrpe_user        = 'nagios'
      $nrpe_group       = 'nagios'
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
      $nrpe_user        = 'nrpe'
      $nrpe_group       = 'nrpe'
      $nrpe_pid_file    = '/var/run/nrpe/nrpe.pid'
      $nrpe_config      = '/etc/nagios/nrpe.cfg'
      $nrpe_include_dir = '/etc/nrpe.d'
      $nrpe_service     = 'nrpe'
      $nrpe_packages    = [
        'nrpe',
        'nagios-plugins-nrpe'
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
