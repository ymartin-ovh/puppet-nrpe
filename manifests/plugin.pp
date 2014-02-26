#
define nrpe::plugin (
  $ensure       = present,
  $source       = false,
  $libdir       = $nrpe::params::libdir,
  $package_name = $nrpe::params::nrpe_packages,
  $file_group   = $nrpe::params::nrpe_files_group,
) {
  file { "${libdir}/${title}":
    ensure  => $ensure,
    source  => $source,
    owner   => 'root',
    group   => $file_group,
    mode    => '0755',
    require => Package[$package_name],
  }
}
