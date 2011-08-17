class ocsinventory::dbconf {
	mysql_db {
		$ocsinventory::dbname:
			pass => $ocsinventory::dbpass,
			user => $ocsinventory::dbuser;

		ocsweb:
			pass => $ocsinventory::dbpass,
			user => $ocsinventory::dbuser;
	}

	mysql_user { $ocsinventory::dbuser:
		pass => $ocsinventory::dbpass,
	}
}
