class ocsinventory::core {
	file {
		'setup.sh':
			ensure => present,
			path => '/tmp/OCSNG_UNIX_SERVER-2.0/setup.sh',
			content => template('ocsinventory/setup.sh.erb'),
			mode => 0755;
	}

	exec {
		'source install':
			command => './setup.sh',
			provider => shell,
			cwd => '/tmp/OCSNG_UNIX_SERVER-2.0';
	}
}
