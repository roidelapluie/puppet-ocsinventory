import 'classes/*'

class ocsinventory (
	$dbuser = 'ocsinventory',
	$dbpass = 'xoh1Dae4',
	$dbname = 'ocsinventory'
) {
	class{'ocsinventory::packages':} -> class{'ocsinventory::dbconf':} -> class{'ocsinventory::core':}
	Exec{path=>'/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'}
}
