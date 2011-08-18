class ocsinventory::core {
	file {
/*
		'setup.sh':
			ensure => present,
			path => '/tmp/OCSNG_UNIX_SERVER-2.0/setup.sh',
			content => template('ocsinventory/setup.sh.erb'),
			mode => 0755;
*/

		'install.php':
			ensure => present,
			path => '/usr/share/ocsinventory-reports/ocsreports/install.php',
			content => template('ocsinventory/install.php.erb'),
			mode => 0644;
	}

	exec {
/*
		'source install':
			command => './setup.sh',
			provider => shell,
			cwd => '/tmp/OCSNG_UNIX_SERVER-2.0';
*/

		'run install.php':
			command => 'php install.php',
			provider => shell,
			require => File['install.php'],
			cwd => '/usr/share/ocsinventory-reports/ocsreports';
	}
}
