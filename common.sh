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