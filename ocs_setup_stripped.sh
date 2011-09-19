#!/bin/sh

# DB config
DB_SERVER_HOST="<%= scope.lookupvar('ocsinventory::db_host') %>"
DB_SERVER_PORT="<%= scope.lookupvar('mysql::port') %>"
DB_SERVER_USER="<%= scope.lookupvar('ocsinventory::db_user') %>"
DB_SERVER_PWD="<%= scope.lookupvar('ocsinventory::db_pass') %>"

# Apache config
APACHE_BIN="<%= scope.lookupvar('ocsinventory::apache_bin') %>"
APACHE_CONFIG_FILE="<%= scope.lookupvar('apache::config_file') %>"
APACHE_CONFIG_DIRECTORY="<%= scope.lookupvar('apache::config_dir') %>"
APACHE_USER="<%= scope.lookupvar('apache::user') %>"
APACHE_GROUP="<%= scope.lookupvar('apache::group') %>"
APACHE_ROOT_DOCUMENT="<%= scope.lookupvar('apache::docroot') %>"
APACHE_MOD_PERL_VERSION="2" # use 1 for perl versions before 1.99

# OCS config
# Where are located OCS Communication server log files
OCS_COM_SRV_LOG="/var/log/ocsinventory-server"
# Where is located perl interpreter
PERL_BIN=`which perl 2>/dev/null`
# Where is located make utility
MAKE=`which make 2>/dev/null`
# Where is located logrotate configuration directory
LOGROTATE_CONF_DIR="/etc/logrotate.d"
# Where is located newsyslog.conf 
NEWSYSLOG_CONF_FILE="/etc/newsyslog.conf"
# Where to store setup logs
SETUP_LOG=`pwd`/ocs_server_setup.log
# Communication Server Apache configuration file
COM_SERVER_APACHE_CONF_FILE="ocsinventory-server.conf" 
# Communication Server logrotate configuration file
COM_SERVER_LOGROTATE_CONF_FILE="ocsinventory-server" 
# Administration Console Apache configuration file
ADM_SERVER_APACHE_CONF_FILE="ocsinventory-reports.conf"
# Administration console read only files directory
ADM_SERVER_STATIC_DIR="/usr/share/ocsinventory-reports"
ADM_SERVER_STATIC_REPORTS_DIR="ocsreports"
ADM_SERVER_REPORTS_ALIAS="/ocsreports"
# Administration console read/write files dir
ADM_SERVER_VAR_DIR="/var/lib/ocsinventory-reports"
# Administration default packages directory and Apache alias
ADM_SERVER_VAR_PACKAGES_DIR="download"
ADM_SERVER_PACKAGES_ALIAS="/download"
# Administration default snmp directory, Apache alias and SNMP communities file
ADM_SERVER_VAR_SNMP_DIR="snmp"
ADM_SERVER_SNMP_ALIAS="/snmp"
ADM_SERVER_SNMPCOM_FILE="snmp_com.txt"
# Administration console default ipdsicover-util.pl cache dir
ADM_SERVER_VAR_IPD_DIR="ipd"

UNIX_DISTRIBUTION=""
<% if scope.lookupvar('::operatingsystem') == 'centos' then -%>

OCS_LOCAL_DATE=`date +%Y-%m-%d-%H-%M-%S`

DB_CLIENT_MAJOR_VERSION=`eval mysql -V | cut -d' ' -f6 | cut -d'.' -f1` >> $SETUP_LOG 2>&1
DB_CLIENT_MINOR_VERSION=`eval mysql -V | cut -d' ' -f6 | cut -d'.' -f2` >> $SETUP_LOG 2>&1

$deps = ['make', 'mod_perl'
$MAKE

    # Check for required Perl Modules (if missing, please install before)
    #    - DBI 1.40 or higher
    #    - Apache::DBI 0.93 or higher
    #    - DBD::mysql 2.9004 or higher
    #    - Compress::Zlib 1.33 or higher
    #    - XML::Simple 2.12 or higher
    #    - Net::IP 1.21 or higher

    # Check for optional Perl Modules
    #    - SOAP::Lite 0.65, not required, used only in web service
    #    - XML::Entities 0.02, not required, used only in web service

    cd "Apache"
    $PERL_BIN Makefile.PL
    $MAKE >> $SETUP_LOG 2>&1
    $MAKE install >> $SETUP_LOG 2>&1
    mkdir -p $OCS_COM_SRV_LOG >> $SETUP_LOG 2>&1
    chown -R $APACHE_USER:$APACHE_GROUP $OCS_COM_SRV_LOG >> $SETUP_LOG 2>&1
    chmod -R gu+rwx $OCS_COM_SRV_LOG >> $SETUP_LOG 2>&1
    chmod -R o-w $OCS_COM_SRV_LOG >> $SETUP_LOG 2>&1

    cp etc/ocsinventory/$COM_SERVER_APACHE_CONF_FILE $COM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#DATABASE_SERVER#$DB_SERVER_HOST#g" $COM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#DATABASE_PORT#$DB_SERVER_PORT#g" $COM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#VERSION_MP#$APACHE_MOD_PERL_VERSION#g" $COM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#PATH_TO_LOG_DIRECTORY#$OCS_COM_SRV_LOG#g" $COM_SERVER_APACHE_CONF_FILE.local
    rm -f "$APACHE_CONFIG_DIRECTORY/ocsinventory.conf"

    echo "Where to create writable/cache directories for deployement packages,"
    echo -n "IPDiscover and SNMP [$ADM_SERVER_VAR_DIR] ?"
    read ligne
    if test -z $ligne
    then
       ADM_SERVER_VAR_DIR=$ADM_SERVER_VAR_DIR
    else
       ADM_SERVER_VAR_DIR="$ligne"
    fi
    echo "OK, writable/cache directory is $ADM_SERVER_VAR_DIR ;-)"
    echo "Using $ADM_SERVER_VAR_DIR as writable/cache directory" >> $SETUP_LOG
    echo

    mkdir -p $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR >> $SETUP_LOG 2>&1
    cp -Rf ocsreports/* $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/ >> $SETUP_LOG 2>&1
    chown -R root:$APACHE_GROUP $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR >> $SETUP_LOG 2>&1
    chmod -R go-w $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR >> $SETUP_LOG 2>&1

    rm -f $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo "<?php" >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo -n '$_SESSION["SERVEUR_SQL"]="' >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo -n "$DB_SERVER_HOST" >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo '";' >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo -n '$_SESSION["COMPTE_BASE"]="' >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo -n "$DB_SERVER_USER" >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo '";' >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo -n '$_SESSION["PSWD_BASE"]="' >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo -n "$DB_SERVER_PWD" >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo '";' >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    echo "?>" >> $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    chown root:$APACHE_GROUP $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php
    chmod g+w $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/dbconfig.inc.php >> $SETUP_LOG 2>&1
    mkdir -p $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_IPD_DIR >> $SETUP_LOG 2>&1
    chown -R root:$APACHE_GROUP $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_IPD_DIR >> $SETUP_LOG 2>&1
    chmod -R go-w $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_IPD_DIR >> $SETUP_LOG 2>&1
    chmod g+w $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_IPD_DIR >> $SETUP_LOG 2>&1
    mkdir -p $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_PACKAGES_DIR >> $SETUP_LOG 2>&1
    chown -R root:$APACHE_GROUP $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_PACKAGES_DIR >> $SETUP_LOG 2>&1
    chmod -R g+w,o-w $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_PACKAGES_DIR >> $SETUP_LOG 2>&1
    mkdir -p $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR >> $SETUP_LOG 2>&1
    chown -R root:$APACHE_GROUP $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR >> $SETUP_LOG 2>&1
    chmod -R g+w,o-w $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR >> $SETUP_LOG 2>&1

    if [ -d "$ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR" ]
    then
       if [ ! -f "$ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR/$ADM_SERVER_SNMPCOM_FILE" ]
       then
            echo "Configuring $ADM_SERVER_SNMPCOM_FILE file"
            cp etc/ocsinventory/$ADM_SERVER_SNMPCOM_FILE $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR/$ADM_SERVER_SNMPCOM_FILE >> $SETUP_LOG 2>&1
            if [ $? -ne 0 ]
            then
                 echo "*** ERROR: Unable to copy $ADM_SERVER_SNMPCOM_FILE into $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR/$ADM_SERVER_SNMPCOM_FILE directory"
                 echo
                 echo "Instalaltion aborted"
                 exit 1
            fi
            #Setting owner and group for SNMP communities file 
            chown -R root:$APACHE_GROUP $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR/$ADM_SERVER_SNMPCOM_FILE >> $SETUP_LOG 2>&1
            if [ $? -ne 0 ]
            then
                 echo "*** ERROR: Unable to set permissions on $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR/$ADM_SERVER_SNMPCOM_FILE file, please look at error in $SETUP_LOG and fix !"
                 echo
                 echo "Installation aborted !"
                 exit 1
            fi
            # Set SNMP communnities file writable by root and Apache group only
            chmod -R g+w,o-w $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR/$ADM_SERVER_SNMPCOM_FILE >> $SETUP_LOG 2>&1
            if [ $? -ne 0 ]
            then
                 echo "*** ERROR: Unable to set permissions on $ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR/$ADM_SERVER_SNMPCOM_FILE file , please look at error in $SETUP_LOG and fix !"
                 echo
                 echo "Installation aborted !"
                 exit 1
            fi 
       fi
    fi

    cp binutils/ipdiscover-util.pl ipdiscover-util.pl.local >> $SETUP_LOG 2>&1
    $PERL_BIN -pi -e "s#localhost#$DB_SERVER_HOST#g" ipdiscover-util.pl.local
    $PERL_BIN -pi -e "s#3306#$DB_SERVER_PORT#g" ipdiscover-util.pl.local
    cp ipdiscover-util.pl.local $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/ipdiscover-util.pl >> $SETUP_LOG 2>&1
    chown root:$APACHE_GROUP $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/ipdiscover-util.pl >> $SETUP_LOG 2>&1
    chmod gou+x $ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR/ipdiscover-util.pl >> $SETUP_LOG 2>&1
    
    cp etc/ocsinventory/$ADM_SERVER_APACHE_CONF_FILE $ADM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#OCSREPORTS_ALIAS#$ADM_SERVER_REPORTS_ALIAS#g" $ADM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#PATH_TO_OCSREPORTS_DIR#$ADM_SERVER_STATIC_DIR/$ADM_SERVER_STATIC_REPORTS_DIR#g" $ADM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#IPD_ALIAS#$ADM_SERVER_IPD_ALIAS#g" $ADM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#PATH_TO_IPD_DIR#$ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_IPD_DIR#g" $ADM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#PACKAGES_ALIAS#$ADM_SERVER_PACKAGES_ALIAS#g" $ADM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#PATH_TO_PACKAGES_DIR#$ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_PACKAGES_DIR#g" $ADM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#SNMP_ALIAS#$ADM_SERVER_SNMP_ALIAS#g" $ADM_SERVER_APACHE_CONF_FILE.local
    $PERL_BIN -pi -e "s#PATH_TO_SNMP_DIR#$ADM_SERVER_VAR_DIR/$ADM_SERVER_VAR_SNMP_DIR#g" $ADM_SERVER_APACHE_CONF_FILE.local
    cp -f $ADM_SERVER_APACHE_CONF_FILE.local $APACHE_CONFIG_DIRECTORY/$ADM_SERVER_APACHE_CONF_FILE >> $SETUP_LOG 2>&1
