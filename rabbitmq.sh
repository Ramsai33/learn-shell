source common.

if [ -z ${root_rabbitmq_password} ];then
  echo "missinq rabbitmq password"
  exit
fi

print_head "Downloading Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${LOG}
status_check

print_head "Installing Erlang"
yum install erlang -y &>>${LOG}
status_check

print_head "Downloading rabbitmq Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG}
status_check

print_head "Installing rabbitmq"
yum install rabbitmq-server -y &>>${LOG}
status_check

print_head "Starting Service"
systemctl enable rabbitmq-server &>>${LOG}
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "Password Setup"
rabbitmqctl add_user roboshop ${root_rabbitmq_password} &>>${LOG}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check