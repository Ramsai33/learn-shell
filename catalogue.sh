script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo "success"
  else
    echo "Failure"
    echo "Refer error log file for more information, Log- ${LOG}"
  exit
  fi
}

echo -e "\e[33mDownloadingnodejsrepo\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

echo -e '\e[33m Install Nodejs \e[0m'
yum install nodejs -y &>>${LOG}
status_check

echo -e '\e[33m Creating User \e[0m'
useradd roboshop &>>${LOG}
status_check


echo -e '\e[33m creating app folder\e[0m'
mkdir -p /app &>>${LOG}
status_check

echo -e '\e[33m Downloading App Content \e[0m'
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e '\e[33m removing App content\e[0m'
rm -rf /app/* &>>${LOG}
status_check


cd /app &>>${LOG}

unzip /tmp/catalogue.zip &>>${LOG}

echo -e '\e[33m Installing NPM\e[0m'
npm install &>>${LOG}
status_check

echo -e '\e[33m Downloading nodejs repo\e[0m'
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

echo -e '\e[33m Daemon-Reload \e[0m'
systemctl daemon-reload &>>${LOG}
status_check

echo -e '\e[33m Stating Catalogue Service\e[0m'
systemctl enable catalogue &>>${LOG}
systemctl start catalogue &>>${LOG}
status_check

echo -e '\e[33m Copying Mongo Repo  \e[0m'
cp ${script_location}/files/schemaload.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

echo -e '\e[33m Installing MongoDB \e[0m'
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e '\e[33m Schema Load \e[0m'
mongo --host 172.31.85.198 </app/schema/catalogue.js &>>${LOG}
status_check
