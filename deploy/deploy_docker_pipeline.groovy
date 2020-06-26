pipeline {
    agent master

    stages{
        stage('同步源码') {
            steps {
                git url:'git@github.com:princeqjzh/JeeSite4.git', branch:'master'
            }
        }
    }
}