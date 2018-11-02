#
define nrpe::command (
  String[1]                            $command,
  Enum['present', 'absent']            $ensure       = present,
  Stdlib::Absolutepath                 $include_dir  = $nrpe::include_dir,
  Variant[String[1], Array[String[1]]] $package_name = $nrpe::package_name,
  String[1]                            $service_name = $nrpe::service_name,
  Stdlib::Absolutepath                 $libdir       = $nrpe::params::libdir,
  String[1]                            $file_group   = $nrpe::params::nrpe_files_group,
  Stdlib::Filemode                     $file_mode    = $nrpe::command_file_default_mode,
  Boolean                              $sudo         = false,
  String[1]                            $sudo_user    = 'root',
) {
  file { "${include_dir}/${title}.cfg":
    ensure  => $ensure,
    content => epp(
      'nrpe/command.cfg.epp',
      {
        'command_name' => $name,
        'command'      => $command,
        'sudo'         => $sudo,
        'sudo_user'    => $sudo_user,
        'libdir'       => $libdir,
      },
    ),
    owner   => 'root',
    group   => $file_group,
    mode    => $file_mode,
    require => Package[$package_name],
    notify  => Service[$service_name],
  }
}
