source common.sh

print_head "Repo setup"
cp ${script_location}/files/mongod.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Install MongoDB"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "enable Service"
systemctl enable mongod &>>${LOG}
status_check

print_head "start service"
systemctl start mongod &>>${LOG}
status_check

print_head "Changing Port Details "
sed -i -e 's/127.0.0.1/0.0.0.0/gi' /etc/mongod.conf &>>${LOG}
status_check

print_head "Restart MongoDB"
systemctl restart mongod &>>${LOG}
status_check