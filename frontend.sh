source common.sh

print_head "Installing Nginx"
yum install nginx -y &>>${LOG}
status_check

print_head "Starting Service"
systemctl enable nginx &>>${LOG}
systemctl start nginx &>>${LOG}
status_check


rm -rf /usr/share/nginx/html/* &>>${LOG}

print_head "Downloading web content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

print_head "Extracting web content"
cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "Configuring Reverse Proxy"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check