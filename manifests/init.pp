import 'classes/*'

class ocsinventory {
	class{'ocsinventory::packages':} -> class{'ocsinventory::core':}
	Exec{path=>'/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'}
}
