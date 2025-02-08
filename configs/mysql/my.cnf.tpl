[mysqld]
user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
port            = ${mysql_port}
basedir         = /usr
datadir         = /var/lib/mysql
bind-address    = 0.0.0.0
default_authentication_plugin = mysql_native_password
