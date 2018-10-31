#
define nrpe::command (
  $command,
  $ensure       = present,
  $include_dir  = $nrpe::include_dir,
  $package_name = $nrpe::package_name,
  $service_name = $nrpe::service_name,
  $libdir       = $nrpe::params::libdir,
  $file_group   = $nrpe::params::nrpe_files_group,
  $file_mode    = $nrpe::command_file_default_mode,
  $sudo         = false,
  $sudo_user    = 'root',
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
