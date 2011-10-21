class ocsinventory::packages {
	@package {
		'ocsinventory':
			ensure => latest;
		'ocsinventory-agent':
			ensure => latest;
	}

	realize(Package['ocsinventory-agent'])

	if $ocsinventory::server != no {
		realize(Package['ocsinventory'])
	}

	class source {
		$pkgs=[
			'php-mysql',
			'php-gd',
			'perl-XML-Simple',
			'perl-Compress-Zlib',
			'perl-DBI',
			'perl-DBD-MySQL',
			'perl-Net-IP',
			'perl-XML-Entities',
			'perl-Apache-DBI',
			'perl-Apache2-SOAP',
			'perl-SOAP-Lite',
			'mod_perl'
		]

		package {
			$pkgs:
				ensure => present;
		}

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

}
