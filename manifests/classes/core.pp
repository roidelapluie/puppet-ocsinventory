class ocsinventory::core {
  exec {'Install_OCS_inventory':
    command => "wget --quiet -O /dev/null 'http://127.0.0.1/ocsreports/install.php' --post-data='host=localhost&database=ocsweb&name=${ocsinventory::dbuser}&pass=${ocsinventory::dbpass}'",
    path => '/bin:/usr/bin',
    onlyif => 'test -f /usr/share/ocsinventory-reports/ocsreports/install.php',
  }
  exec {'Install_OCS_inventory_confirm':
    command => "wget --quiet -O /dev/null 'http://127.0.0.1/ocsreports/install.php' --post-data='host=localhost&database=ocsweb&name=${ocsinventory::dbuser}&pass=${ocsinventory::dbpass}'",
    path => '/usr/bin',
    onlyif => 'test -f /usr/share/ocsinventory-reports/ocsreports/install.php',
    require => Exec['Install_OCS_inventory'];
  }
  file {
    '/usr/share/ocsinventory-reports/ocsreports/install.php':
      ensure => absent,
      require => Exec['Install_OCS_inventory_confirm';
  }
}
