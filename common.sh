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

APP_PREREQ() {
  print_head "Creating User"
    useradd roboshop &>>${LOG}
    status_check


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

    cd /app &>>${LOG}
}

SYSTEMD_SETUP() {
     print_head "Daemon-Reload "
       systemctl daemon-reload &>>${LOG}
       status_check

       print_head "Stating ${component}Service"
       systemctl enable ${component} &>>${LOG}
       systemctl start ${component} &>>${LOG}
       status_check

}

LOAD_SCHEMA() {
  if [ ${schema_load} == "true" ]; then
    if [ ${schema_type} == "mongo" ]; then
    print_head "Copying Mongo Repo"
    cp ${script_location}/files/schemaload.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
    status_check

    print_head "Installing MongoDB"
    yum install mongodb-org-shell -y &>>${LOG}
    status_check

    print_head "Schema Load"
    mongo --host mongodb-dev.ramdevops35.online </app/schema/${component}.js &>>${LOG}
    status_check
    fi

      if [ ${schema_type} == "mysql" ]; then
      print_head "Installing Mysql"
      yum install mysql -y &>>${LOG}
      status_check

      print_head "Schema Load"
      mysql -h 172.31.83.153 -uroot -pRoboShop@1 < /app/schema/shipping.sql  </app/schema/${component}.js &>>${LOG}
      systemctl restart ${component}
      status_check
     fi
  fi

}

nodejs() {
  print_head "Downloadingnodejsrepo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

  print_head "Install Nodejs"
  yum install nodejs -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Installing NPM"
  npm install &>>${LOG}
  status_check

  print_head " Downloading nodejs repo"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  SYSTEMD_SETUP

  LOAD_SCHEMA
}

Maven() {
  print_head "Installing Maven"
  yum install maven -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Downloading Dependencies"
  mvn clean package &>>${LOG}
  status_check

  print_head "Moving Dependencies"
  mv target/shipping-1.0.jar shipping.jar &>>${LOG}
  status_check

  print_head "Setup demon user"
  cp ${script_location}/files/shipping.service /etc/systemd/system/shipping.service} &>>${LOG}
  status_check

  SYSTEMD_SETUP
  LOAD_SCHEMA

}