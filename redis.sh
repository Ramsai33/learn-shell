source common.sh

print_head "Creating Redis repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG}
status_check

dnf module enable redis:remi-6.2 -y &>>${LOG}

print_head "Install redis"
yum install redis -y &>>${LOG}
status_check

print_head "Changing Port details"
sed -i -e 's/127.0.0.1/0.0.0.0/gi' /etc/redis.conf &>>${LOG}
status_check

print_head "Stating Service"
systemctl enable redis &>>${LOG}
systemctl start redis &>>${LOG}
status_check