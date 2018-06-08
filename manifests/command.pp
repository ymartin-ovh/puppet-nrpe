#
define nrpe::command (
  String $command,
  Enum['present', 'absent'] $ensure            = present,
  String $include_dir                          = $nrpe::include_dir,
  Variant[String, Array[String]] $package_name = $nrpe::package_name,
  String $service_name                         = $nrpe::service_name,
  String $libdir                               = $nrpe::params::libdir,
  String $file_group                           = $nrpe::params::nrpe_files_group,
  String $file_mode                            = $nrpe::command_file_default_mode,
  Boolean $sudo                                = false,
  String $sudo_user                            = 'root',
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
