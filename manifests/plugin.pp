#
define nrpe::plugin (
  $ensure       = present,
  $content      = undef,
  $source       = undef,
  $libdir       = $nrpe::params::libdir,
  $package_name = $nrpe::params::nrpe_packages,
  $file_group   = $nrpe::params::nrpe_files_group,
) {
  file { "${libdir}/${title}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => $file_group,
    mode    => '0755',
    require => Package[$package_name],
  }
}
