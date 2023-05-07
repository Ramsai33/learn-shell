
cp ${script_location}/files/mongod.repo /etc/yum.repos.d/mongo.repo &>>${LOG}

print_head "Install MongoDB"
yum install mongodb-org -y &>>${LOG}
Status_check

print_head "Stat Service"
systemctl enable mongod &>>${LOG}
systemctl start mongod &>>${LOG}
Status_check

print_head "Changing Port Details "
sed -i -e 's/127.0.0.1/0.0.0.0/gi' /etc/mongod.conf &>>${LOG}
Status_check

print_head "Restart MongoDB "
systemctl restart mongod &>>${LOG}
Status_check