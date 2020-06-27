pipeline {
    agent {
        label 'master'
    }

    environment {
        docker_image_name = 'jeesite4'
        docker_container_name = 'iJeesite4'
    }

    parameters {
        string(name: 'branch', defaultValue: 'master', description: 'Git branch')
    }

    stages{
        stage('同步源码') {
            steps {
                git url:'git@github.com:princeqjzh/JeeSite4.git', branch:'master'
            }
        }

        stage('设定配置文件'){
            steps{
                sh '''
                    . ~/.bash_profile
            
                    export os_type=`uname`
                    cd ${WORKSPACE}/web/bin/docker
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
                '''
            }
        }

        stage('Maven 编译'){
            steps {
                sh '''
                    cd ${WORKSPACE}/root
                    mvn clean install -Dmaven.test.skip=true
                    
                    cd ${WORKSPACE}/web
                    mvn clean package spring-boot:repackage -Dmaven.test.skip=true -U
                '''
            }
        }

        stage('停止 / 删除 现有Docker Container/Image '){
            steps {
                sh '''
                    docker stop $docker_container_name
                    docker rm $docker_container_name
                    docker rmi $docker_image_name
                '''
            }
        }
    }
}