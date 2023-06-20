#!/bin/bash

function showUsage() {
    scriptName=`basename $0`
    echo ""
    echo "usage: ./$scriptName [command] [options]"
    echo ""
    echo "Commands:"
    echo ""
    echo "  copyfrom [-h host] [-u user] \\"
    echo "           [-n name] [-port p]         copy remote db to the local"
    echo ""
    echo "  restore  [-f filename]               restore a backup file to local"
    echo ""
}

function validateCommand() {
    if [ $# -lt 1 ] ; then
        echo "Invalid usage of validateCommand. Expecting 1 argument."
        exit 1
    fi
    validCommands=( "copyfrom" "restore")
    for validCommand in "${validCommands[@]}"
    do
        if [ "$1" == "${validCommand}" ] ; then
            valid=0
            return
        fi
    done
    return 1
}

function copyDB() {
  VALID=1
  if [ "$DB_HOST" == "" ]; then
    echo "[!] missing -h host"
    VALID=0
  fi

  if [ "$DB_USER" == "" ]; then
    echo "[!] missing -u user"
    VALID=0
  fi

  if [ "$DB_NAME" == "" ]; then
    echo "[!] missing -n dbname"
    VALID=0
  fi


  if [ "$DB_TO" == "" ]; then
    echo "[!] missing -to dbname"
    VALID=0
  fi

  if [ $VALID -eq 0 ]; then
    showUsage
    exit 1
  fi

  echo "Creating dump..."
  mysqldump -u $DB_USER -p$DB_PASS -h $DB_HOST --port $DB_PORT $DB_NAME > /tmp/dump.sql
  echo "Importing dump..."
  mysql -u root $DB_TO < /tmp/dump.sql
  rm /tmp/dump.sql
}

if [ $# -eq 0 ] ; then
    showUsage
    exit 1
fi

command=$1
shift

if ! validateCommand ${command} ; then
    showUsage
    exit 1
fi

DB_PORT=3306

# smart CLI arguments: http://linuxcommand.org/wss0130.php
while [ "$1" != "" ]; do
    case $1 in
        -h)         shift
                    DB_HOST=$1
                    ;;
        -port)      shift
                    DB_PORT=$1
                    ;;
        -u)         shift
                    DB_USER=$1
                    ;;
        -p)         shift
                    DB_PASS=$1
                    ;;
        -n)         shift
                    DB_NAME=$1
                    ;;
        -to)        shift
                    DB_TO=$1
                    ;;

        * )         echo ""
                    echo "[!] invalid option $1"
                    echo ""
                    showUsage
                    exit 1
    esac
    shift
done

case ${command} in
    copyfrom )              copyDB
                            ;;
    restore )               restoreDB
                            ;;
esac
