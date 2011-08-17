import 'classes/*'

class ocsinventory (
	$dbuser = 'ocs',
	$dbpass = 'xoh1Dae4',
	$dbname = 'ocs',
	$dbhost = 'localhost',
	$dbport = '3306',
	$server = 'no'
) {
	class{'ocsinventory::iptables':} -> class{'ocsinventory::repo':} -> class{'ocsinventory::packages':} -> class{'ocsinventory::dbconf':} -> class{'ocsinventory::core':} -> class{'ocsinventory::config':}
	Exec{path=>'/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'}
}
