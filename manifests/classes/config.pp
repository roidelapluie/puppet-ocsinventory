class ocsinventory::config {
	file {
		'/etc/ocsinventory/ocsinventory-reports/dbconfig.inc.php':
			ensure => present,
			mode => 0666,
			content => template('ocsinventory/dbconfig.inc.php.erb');

		'/etc/httpd/conf.d/ocsinventory-server.conf':
			ensure => present,
			notify => Service["$ocsinventory::webserver"],
			content => template('ocsinventory/ocsinventory-server.conf.erb');
	}
}
