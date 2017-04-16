# OpenEMR-on-macOS


**Installing Apache**



```shell
brew tap homebrew/dupes
 brew tap homebrew/versions
 brew tap homebrew/php
 brew tap homebrew/apache
brew install httpd24 --with-privileged-ports --with-http2
```

Changes required in Apache configuration

`User your_user`
`Group admin`

`LoadModule rewrite_module libexec/mod_rewrite.so`



In the same `<Directory>` block you will find an `AllowOverride` setting, this should be changed as follows:

```http
# AllowOverride controls what directives may be placed in .htaccess files.
# It can be "All", "None", or any combination of the keywords:
#   AllowOverride FileInfo AuthConfig Limit
#
AllowOverride All
```

**Installing PHP**



`brew unlink php71`

`brew install php71 --with-httpd24



**OpenEMR specific**



get OpenEMR from github to a working directory

Say:

/Users/user/hack/code/openemr

We need to run Apache as the same user as that of logged in user so that there are no permission issues. This will also help us to run the code in a location writable by the non-admin user (ie developer).

For a Homebrew based install, the default Apache Document root is

/usr/local/var/www/htdocs

For our purposes, we will deploy the test code to the above folder.



`cd /Users/user/hack/code/'

git clone <openEMR>

make changes to the code.

Once done, run the script **refresh.openEMR.sh**

`cd /Users/user/hack/code/`

`bash refresh.openEMR.sh`

`
