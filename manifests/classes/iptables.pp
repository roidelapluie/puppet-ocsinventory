class ocsinventory::iptables {
	service {
		'iptables':
			ensure => stopped,
			enable => false,
	}
}
