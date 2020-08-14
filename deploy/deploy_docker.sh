#!/usr/bin/env bash

## 需要在Jenkins任务中配置以下参数
#export mysql_ip=mysql server ip or host
#export mysql_port=mysql port
#export mysql_user=mysql username
#export mysql_pwd=mysql password
#export PROJ_PATH=project path
export docker_image_name=jeesite4
export docker_container_name=iJeesite4

## 检查系统类型
export os_type=`uname`

## 配置数据库参数
cd $PROJ_PATH/web/bin/docker
if [[ "${os_type}" == "Darwin" ]]; then
	sed -i "" "s/mysql_ip/${mysql_ip}/g" application-prod.yml
  sed -i "" "s/mysql_port/${mysql_port}/g" application-prod.yml
  sed -i "" "s/mysql_user/${mysql_user}/g" application-prod.yml
  sed -i "" "s/mysql_pwd/${mysql_pwd}/g" application-prod.yml
else
  sed -i "s/mysql_ip/${mysql_ip}/g" application-prod.yml
  sed -i "s/mysql_port/${mysql_port}/g" application-prod.yml
  sed -i "s/mysql_user/${mysql_user}/g" application-prod.yml
  sed -i "s/mysql_pwd/${mysql_pwd}/g" application-prod.yml
fi

## Maven 编译
cd $PROJ_PATH/root
mvn clean install -Dmaven.test.skip=true

## Maven 打包
cd $PROJ_PATH/web
mvn clean package spring-boot:repackage -Dmaven.test.skip=true -U

## 停止/删除 现有的Docker container
docker stop $docker_container_name
docker rm $docker_container_name
docker rmi $docker_image_name

## 生成新的docker image
cd $PROJ_PATH/web/bin/docker
rm -f web.war
cp $PROJ_PATH/web/target/web.war .
docker build -t $docker_image_name .

## 启动新的docker image 暴露端口 8981
docker run -d --name $docker_container_name -p 8981:8980 $docker_image_name