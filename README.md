# OpenEMR-on-macOS



**Installations handled in the script**

Instllations are moved to the script. Though PHP and Apache installation and commented out for the time being. Those two must be custom installed at this point.

**Installing PHP**



`brew unlink php71`

`brew install php71 --with-httpd24

**Installing Apache**



```shell
brew tap homebrew/dupes
 brew tap homebrew/versions
 brew tap homebrew/php
 brew tap homebrew/apache
brew install httpd24 --with-privileged-ports --with-http2
```


**Changes required in Apache configuration**


The following change mentions which user and group should be used by the web server to execute its processes. This is chosen to be the developer user to avoid any permission issues. The user can be identified from the $LOGNAME environment vairable

echo $LOGNAME from shell will give your logged in user name (your_user)

```shell
User your_user
Group admin
```


We will mod_rewrite plugin to enable rewrite rules.

`LoadModule rewrite_module libexec/mod_rewrite.so`



In the same `<Directory>` block you will find an `AllowOverride` setting, this should be changed as follows:

```http
# AllowOverride controls what directives may be placed in .htaccess files.
# It can be "All", "None", or any combination of the keywords:
#   AllowOverride FileInfo AuthConfig Limit
#
AllowOverride All
```




**OpenEMR specific**



get OpenEMR from github to a working directory

Say:

/Users/user/hack/code/openemr

We need to run Apache as the same user as that of logged in user so that there are no permission issues. This will also help us to run the code in a location writable by the non-admin user (ie developer).

For a Homebrew based install, the default Apache Document root is

/usr/local/var/www/htdocs

For our purposes, we will deploy the test code to the above folder.



`cd /Users/$LOGNAME/hack/code/'

git clone <openEMR>

make changes to the code.

Once done, run the script **refresh_openEMR.sh**

`cd /Users/user/hack/code/`

`bash refresh_openEMR.sh`


