#!/usr/bin/env bash

## 需要在Jenkins任务中配置以下参数
# 需要使用docker形式启动mysql, docker container名称必须命名为prod_mysql
# export mysql_port=mysql port
# export mysql_user=mysql username
# export mysql_pwd=mysql password
# export PROJ_PATH=project path
export docker_image_name=jeesite4
export docker_container_name=iJeesite4

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
docker run -d --name $docker_container_name -p 8981:8980 --link prod_mysql:db \
  -e mysql_ip=db -e mysql_port=$mysql_port -e mysql_user=$mysql_user -e mysql_pwd=$mysql_pwd $docker_image_name