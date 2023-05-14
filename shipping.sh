source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing"
  exit
fi

component=shipping

load_schema=true

schema_type=mysql

Maven