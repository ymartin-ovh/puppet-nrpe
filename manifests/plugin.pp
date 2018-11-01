#
define nrpe::plugin (
  Enum['present', 'absent']            $ensure       = present,
  Optional[String[1]]                  $content      = undef,
  Optional[Stdlib::Filesource]         $source       = undef,
  Stdlib::Filemode                     $mode         = $nrpe::params::nrpe_plugin_file_mode,
  Stdlib::Absolutepath                 $libdir       = $nrpe::params::libdir,
  Variant[String[1], Array[String[1]]] $package_name = $nrpe::params::nrpe_packages,
  String[1]                            $file_group   = $nrpe::params::nrpe_files_group,
) {
  file { "${libdir}/${title}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => $file_group,
    mode    => $mode,
    require => Package[$package_name],
  }
}
