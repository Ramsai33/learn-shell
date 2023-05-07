script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[33mDownloadingnodejsrepo\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m Install Nodejs \e[0m'
yum install nodejs -y &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m Creating User \e[0m'
useradd roboshop &>>${LOG}
if [ $? -eq 0 ];
then
  echo "success"
else
  echo "Failure"
fi


echo -e '\e[33m creating app folder\e[0m'
mkdir -p /app &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi
echo -e '\e[33m Downloading App Content \e[0m'
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m removing App content\e[0m'
rm -rf /app/* &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi


cd /app &>>${LOG}

unzip /tmp/catalogue.zip &>>${LOG}

echo -e '\e[33m Installing NPM\e[0m'
npm install &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m Downloading nodejs repo\e[0m'
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m Daemon-Reload \e[0m'
systemctl daemon-reload &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m Stating Catalogue Service\e[0m'
systemctl enable catalogue &>>${LOG}
systemctl start catalogue &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m Copying Mongo Repo  \e[0m'
cp ${script_location}/files/schemaload.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m Installing MongoDB \e[0m'
yum install mongodb-org-shell -y &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

echo -e '\e[33m Schema Load \e[0m'
mongo --host 172.31.85.198 </app/schema/catalogue.js &>>${LOG}
if [ $? -eq 0 ]
then
  echo "success"
else
  echo "Failure"
fi

