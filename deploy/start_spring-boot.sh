#!/usr/bin/env bash

## 检查系统类型
export os_type=`uname`

## 停止spring-boot函数
killSpringBoot()
{
    pid=`ps -ef|grep spring-boot|grep java|awk '{print $2}'`
    echo "spring-boot list :$pid"
    if [ "$pid" = "" ]
    then
      echo "no spring-boot pid alive"
    else
      kill -9 $pid
    fi
}

## Kill 当前正在运行的spring-boot
killSpringBoot

## Maven 编译
cd ${WORKSPACE}/root
mvn clean install

## Maven 运行
cd ${WORKSPACE}/web
nohup mvn clean spring-boot:run -Dmaven.test.skip=true &
