#!/bin/bash
#
# Copyright (C) 2014 Brady Miller <brady@sparmy.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This is a modified version Ubuntu script to prepare a github repository for testing
# in macOS. This is specifically to allow quick testing of new code, and is not for
#  production use.
#
# This script will copy the current checked git repository into
#  the web directory (and remove the currently installed openemr).
# Place this script in the git directory (one level above the openemr
#  directory).
# Note you need to install openemr with the mysql user 'openemr' and
#  the mysql database 'openemr' for this script to completely remove
#  OpenEMR.
# Also note the root mysql password needs to be blank for the mysql
#  and mysqladmin commands to work.
#
# This script can also be used on your cvs checkout if you place it in
#  the cvs directory (one directory above openemr)
#


OPENEMR_DOCROOT=/usr/local/var/www/htdocs/openemr


# install block
# TODO : check whether various softwares and installed and proceed accrodingly

brew install mariadb
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/php
brew tap homebrew/apache
#brew install httpd24 --with-privileged-ports --with-http2
#brew install php71 --with-httpd24

# end install block


# Remove current test copy of openemr
# modifying for Mac
sudo rm -fr /usr/local/var/www/htdocs/openemr


# Remove current openemr mysql database
sudo mysqladmin -f -h localhost -u root drop openemr

# Remove current openemr mysql user
sudo mysql -f -u root -h localhost -e "DELETE FROM mysql.user WHERE User = 'openemr';FLUSH PRIVILEGES;"

# Copy the new openemr version to the web directory (note need to ignore the .git directory)
sudo rsync --recursive --links --exclude .git openemr/* $OPENEMR_DOCROOT

# modify permissions
sudo chmod 666 $OPENEMR_DOCROOT/sites/default/sqlconf.php
# macOS brew install, the user permissions are $APACHE_USER:admin

# running apache as the user and group listed below
# this is done to give developer user access to the files in the doc root
APACHE_USER= $LOGNAME
APACHE_GROUP=admin

sudo chown -R $APACHE_USER:$APACHE_GROUP $OPENEMR_DOCROOT

sudo chown $APACHE_USER:$APACHE_GROUP $OPENEMR_DOCROOT/interface/modules/zend_modules/config/application.config.php
sudo chown -R $APACHE_USER:$APACHE_GROUP $OPENEMR_DOCROOT/sites/default/documents
sudo chown -R $APACHE_USER:$APACHE_GROUP $OPENEMR_DOCROOT/sites/default/edi
sudo chown -R $APACHE_USER:$APACHE_GROUP $OPENEMR_DOCROOT/sites/default/era
sudo chown -R $APACHE_USER:i$APACHE_GROUP $OPENEMR_DOCROOT/library/freeb
sudo chown -R $APACHE_USER:$APACHE_GROUP $OPENEMR_DOCROOT/sites/default/letter_templates
sudo chown -R $APACHE_USER:admin $OPENEMR_DOCROOT/interface/main/calendar/modules/PostCalendar/pntemplates/compiled
sudo chown -R $APACHE_USER:admin $OPENEMR_DOCROOT/interface/main/calendar/modules/PostCalendar/pntemplates/cache
sudo chown -R $APACHE_USER:admin $OPENEMR_DOCROOT/gacl/admin/templates_c

# Restart the mysql server
mysql.server restart
# sudo cp openemr.conf /etc/apache2/sites-available/
# sudo a2ensite openemr.conf
sudo /usr/local/bin/apachectl  restart
