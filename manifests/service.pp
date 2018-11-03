# @api private
class nrpe::service
{
  service { $nrpe::service_name:
    ensure => running,
    enable => true,
  }
}
