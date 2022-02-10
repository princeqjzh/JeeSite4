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
                git url:'git@gitee.com:11547299/jeesite4.git', branch:"$params.branch"
            }
        }

        stage('Maven 编译'){
            steps {
                sh '''
                    . ~/.bash_profile 
                    
                    cd ${WORKSPACE}/root
                    mvn clean install -Dmaven.test.skip=true
                    
                    cd ${WORKSPACE}/web
                    mvn clean package spring-boot:repackage -Dmaven.test.skip=true -U
                '''
            }
        }

        stage('停止 / 删除 现有Docker Container/Image '){
            steps {
                script{
                    try{
                        sh 'docker stop $docker_container_name'
                    }catch(exc){
                        echo 'The container $docker_container_name does not exist'
                    }

                    try{
                        sh 'docker rm $docker_container_name'
                    }catch(exc){
                        echo 'The container $docker_container_name does not exist'
                    }

                    try{
                        sh 'docker rmi $docker_image_name'
                    }catch(exc){
                        echo 'The docker image $docker_image_name does not exist'
                    }
                }
            }
        }

        stage('生成新的Docker Image'){
            steps {
                sh '''
                    cd ${WORKSPACE}/web/bin/docker
                    rm -f web.war
                    cp ${WORKSPACE}/web/target/web.war .
                    docker build -t $docker_image_name .
                '''
            }
        }

        stage('启动新Docker实例'){
            steps {
                sh '''
                    docker run -d --name $docker_container_name -p 8981:8980 --link prod_mysql:db \
                            -e mysql_ip=db -e mysql_port=${mysql_port} -e mysql_user=${mysql_user} \
                            -e mysql_pwd=${mysql_pwd} $docker_image_name
                '''
            }
        }
    }
}