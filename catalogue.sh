source common.sh

print_head "Downloadingnodejsrepo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install Nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Creating User"
useradd roboshop &>>${LOG}
status_check


print_head "creating app folder"
mkdir -p /app &>>${LOG}
status_check

print_head "Downloading App Content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head " removing App content"
rm -rf /app/* &>>${LOG}
status_check


cd /app &>>${LOG}

unzip /tmp/catalogue.zip &>>${LOG}

print_head "Installing NPM"
npm install &>>${LOG}
status_check

print_head " Downloading nodejs repo"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "Daemon-Reload "
systemctl daemon-reload &>>${LOG}
status_check

print_head "Stating Catalogue Service"
systemctl enable catalogue &>>${LOG}
systemctl start catalogue &>>${LOG}
status_check

print_head "Copying Mongo Repo"
cp ${script_location}/files/schemaload.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Installing MongoDB \e[0m'
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "Schema Load"
mongo --host 172.31.85.198 </app/schema/catalogue.js &>>${LOG}
status_check
