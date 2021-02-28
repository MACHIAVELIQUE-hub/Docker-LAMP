#!/bin/bash

apt-get -y install expect

MYSQL_ROOT_PASSWORD=awordrootpass

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"\"

expect \"Set root password? [Y/n]?\"
send \"Y\"

expect \"New password:\"
send \"${MYSQL_ROOT_PASSWORD}\"

expect "Re-enter new password:"
send \"${MYSQL_ROOT_PASSWORD}\"

expect \"Remove anonymous users? [Y/n] \"
send \"Y\"

expect \"Disallow root login remotely? [Y/n] \"
send \"Y\"

expect \"Remove test database and access to it? [Y/n] ?\"
send \"Y\"

expect \"Reload privilege tables now? [Y/n] \"
send \"Y\"

expect eof
")

echo "$SECURE_MYSQL"

apt-get -y purge expect