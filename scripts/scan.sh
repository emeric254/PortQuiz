#!/bin/bash

# nmap variant
which nmap > /dev/null 2> /dev/null;
if [ $? -eq 0 ]
then
  echo "scan started using nmap"
  nmap portquiz.net > port_list.txt
  exit 0
fi

#
timeout=3
lowest_port=1
highest_port=65535
echo '' > port_list.txt

# curl variant
which curl > /dev/null 2> /dev/null
if [ $? -eq 0 ]
then
  echo "scan started using curl"
  for ((port=lowest_port; port<=highest_port; ++port))
  do
    curl --connect-timeout $timeout -s http://portquiz.net:$port > /dev/null 2> /dev/null
    if [ $? -eq 0 ]
    then
      echo "$port/tcp open" >> port_list.txt
    else
      echo "$port/tcp closed" >> port_list.txt
    fi
  done
  exit 0
fi

# wget variant
which wget > /dev/null 2> /dev/null
if [ $? -eq 0 ]
then
  echo "scan started using wget"
  for ((port=lowest_port; port<=highest_port; ++port))
  do
    wget --spider -T $timeout -q http://portquiz.net:$port > /dev/null 2> /dev/null
    if [ $? -eq 0 ]
    then
      echo "$port/tcp open" >> port_list.txt
    else
      echo "$port/tcp closed" >> port_list.txt
    fi
  done
  exit 0
fi

# nc variant (5 sec timeout)
which nc > /dev/null 2> /dev/null
if [ $? -eq 0 ]
then
  echo "scan started using nc"
  for ((port=lowest_port; port<=highest_port; ++port))
  do
    nc -d -z portquiz.net $port -w $timeout > /dev/null 2> /dev/null
    if [ $? -eq 0 ]
    then
      echo "$port/tcp open" >> port_list.txt
    else
      echo "$port/tcp closed" >> port_list.txt
    fi
  done
exit 0
fi

echo 'Error: mising tools to perform the port scan'
echo 'please make sure nmap, curl, wget or nc are available'
exit 1
