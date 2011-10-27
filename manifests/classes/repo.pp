class ocsinventory::repo {
	realize(File['epel-gpg-key'], Yumrepo['epel'], Yumrepo['inuits-private'])
}
