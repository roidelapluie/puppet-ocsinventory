import 'classes/*'

class ocsinventory (
	$dbpass,
	$dbuser = 'ocs',
	$dbname = 'ocs',
	$dbhost = 'localhost',
	$dbport = '3306',
	$server = 'no',
	$webserver = 'httpd'
) {
	class {
		'ocsinventory::iptables':
			before => Class['ocsinventory::repo'];
		'ocsinventory::repo':
			before => Class['ocsinventory::packages'];
		'ocsinventory::packages':
			before => Class['ocsinventory::dbconf'];
		'ocsinventory::dbconf':
			before => Class['ocsinventory::config'];
		'ocsinventory::config':
			before => Class['ocsinventory::core'];
		'ocsinventory::core':;
	}

	Exec {
		path=> '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'
	}
}
