class ocsinventory::packages {
	exec {
		'source download':
			command => 'wget http://launchpad.net/ocsinventory-server/stable-2.0/2.0/+download/OCSNG_UNIX_SERVER-2.0.tar.gz',
			creates => '/tmp/OCSNG_UNIX_SERVER-2.0.tar.gz',
			cwd => '/tmp';

		'source unpack':
			command => 'tar xzvf OCSNG_UNIX_SERVER-2.0.tar.gz',
			creates => '/tmp/OCSNG_UNIX_SERVER-2.0',
			cwd => '/tmp';
	}

	Exec['source download'] -> Exec['source unpack']
}
