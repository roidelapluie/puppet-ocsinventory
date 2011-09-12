import 'classes/*'

class ocsinventory (
	$dbuser = 'ocs',
	$dbpass = 'xoh1Dae4',
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
			before => Class['ocsinventory::core'];
		'ocsinventory::core':
			before => Class['ocsinventory::config'];
		'ocsinventory::config':;
	}

	Exec {
		path=> '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'
	}
}
