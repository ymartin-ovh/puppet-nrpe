#
define nrpe::plugin (
  $ensure       = present,
  $source       = false,
  $libdir       = $nrpe::params::libdir,
  $package_name = $nrpe::params::nrpe_packages
) {
  file { "${libdir}/${title}":
    ensure  => $ensure,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package[$package_name],
  }
}
