class ocsinventory::config {
	file {
		'/etc/ocsinventory/ocsinventory-reports/dbconfig.inc.php':
			ensure => present,
			mode => 0666,
			content => template('ocsinventory/dbconfig.inc.php.erb');

		'/usr/share/ocsinventory-reports/ocsreports/install.php':
			ensure => absent;
	}
}
