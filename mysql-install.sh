#!/bin/bash
# set -e
SCRIPTNAME="$0"
function usage ()
{
  printf "\n\n Script for MYSQL Installation\n"
  printf " usage: ${SCRIPTNAME} [-PARAMETER] value (case exist)\n\n"
  printf " -i = Install Mysql packages and Mysql Workbench, if necessary\n"
  printf " -u = Uninstall Mysql packages\n"
  printf " -h = Show help usage\n"
  printf " \n\t Script Developed by Everton Gonçalves\n"
  printf " \t Gitlab: https://gitlab.com/dsgeverton \n\n"

}

function install ()
{
  sudo apt-get update > /dev/null
  sudo dpkg -l | grep mysql-server-* > /dev/null
  if [[ $? -eq 1 ]]; then
    sudo apt-get install mysql-server -y
    sudo apt-get install mysql-client -y
    sudo service mysql start
  else
    echo "Mysql server package is already installed"
  fi
    local opc='n'
    sudo dpkg -l | grep mysql-workbench > /dev/null
    if [[ $? -eq 1 ]]; then
      read -p "Deseja instalar o Mysql WorkBench [s/N] ? " opc
      while [[ ${opc,,} != 's' && ${opc,,} != 'n' ]]; do
        read opc
      done

      if [[ ${opc,,} == 's' ]]; then
        printf "Installing Mysql WorkBench... "
        sudo apt-get install mysql-workbench -y > /dev/null
        [[ $? -eq 0 ]] && printf "OK!\n" || printf "FAIL!\n"
      fi
    fi
    printf "\nFinish installation!\n\n"
}

function uninstall ()
{
  echo "Removing Mysql Packages..."
  sudo dpkg -l mysql-server
  sudo apt-get remove --purge mysql-server -y > /dev/null 2>&1
  sudo apt-get remove --purge phpmyadmin -y > /dev/null 2>&1
  sudo /etc/init.d/mysql stop
  sudo apt-get remove --purge mysql-common -y > /dev/null 2>&1
  sudo rm -rf /var/lib/mysql -y

  sudo apt-get autoremove --purge -y > /dev/null 2>&1
  sudo apt-get autoclean
  sudo apt-get clean
  echo "Finish!"
}

function main ()
{
  while getopts ":iuh" opc; do
    case $opc in
      i)
        install
        ;;
      u)
        uninstall
        ;;
      h)
        usage
        ;;
      *)
        echo "Invalid option: '$1'"
        usage ;;
    esac
    exit 0
  done
  usage
}

main "$@"
