source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing"
  exit
fi

print_head "Disable Mysql Module"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "Repo Setup"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install MySql"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "start Mysql Service"
systemctl enable mysqld &>>${LOG}
systemctl start mysqld &>>${LOG}
status_check

print_head "Password setup"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
status_check

