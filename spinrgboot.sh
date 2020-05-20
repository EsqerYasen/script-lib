#!/bin/bash

##使用方法 sh 脚本名称 jar包名称
##  sh springboot.sh app.jar

SpringBoot=$2

if [ "$1" = "" ];
then
    echo -e "未输入操作名 {start|stop|restart|status}"
    exit 1
fi

if [ "$SpringBoot" = "" ];
then
    echo -e "未输入应用名"
    exit 1
fi

function start()
{
    count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    if [ $count != 0 ];then
        echo "$SpringBoot is running..."
    else
        echo "Start $SpringBoot success..."
        nohup java -jar $SpringBoot > /dev/null 2>&1 &
    fi
}

function stop()
{
    echo "Stop $SpringBoot"
    boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
    count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`

    if [ $count != 0 ];then
        kill $boot_id
        count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`

        boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
        kill -9 $boot_id
    fi
}

function restart()
{
    stop
    sleep 2
    start
}

function status()
{
    count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    if [ $count != 0 ];then
        echo "$SpringBoot is running..."
    else
        echo "$SpringBoot is not running..."
    fi
}

case $1 in
    start)
    start;;
    stop)
    stop;;
    restart)
    restart;;
    status)
    status;;
    *)

    echo  "Usage:  sh   $0  {start|stop|restart|status}  {SpringBootJarName} "
    echo  "Example: sh  $0  start esmart-test.jar"
esac