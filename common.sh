script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
  else
    echo -e "\e[31m Failure \e[0m"
    echo "Refer error log file for more information, Log- ${LOG}"
  exit
  fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

nodejs() {
  print_head "Downloadingnodejsrepo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

  print_head "Install Nodejs"
  yum install nodejs -y &>>${LOG}
  status_check

#  print_head "Creating User"
#  useradd roboshop &>>${LOG}
#  status_check


  print_head "creating app folder"
  mkdir -p /app &>>${LOG}
  status_check

  print_head "Downloading App Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

  print_head " removing App content"
  rm -rf /app/* &>>${LOG}
  status_check


  cd /app &>>${LOG}

  unzip /tmp/${component}.zip &>>${LOG}

  print_head "Installing NPM"
  npm install &>>${LOG}
  status_check

  print_head " Downloading nodejs repo"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  print_head "Daemon-Reload "
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "Stating ${component}Service"
  systemctl enable ${component} &>>${LOG}
  systemctl start ${component} &>>${LOG}
  status_check

  print_head "Copying Mongo Repo"
  cp ${script_location}/files/schemaload.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
  status_check

  print_head "Installing MongoDB \e[0m"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check

  print_head "Schema Load"
  mongo --host 172.31.80.241 </app/schema/${component}.js &>>${LOG}
  status_check
}