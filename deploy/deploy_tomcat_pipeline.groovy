stage('同步源码') {
    node('master'){
        git([url: 'git@github.com:princeqjzh/JeeSite4.git', branch: 'master'])
    }
}

stage('maven编译打包') {
    node('master'){
        sh ". ~/.bash_profile"

        //获取环境变量
        def mvnHome = tool 'maven-3.6.0_master'
        env.PATH = "${mvnHome}/bin:${env.PATH}"
        sh '''
            export pwd=`pwd`
            export os_type=`uname`
            cd web/src/main/resources/config
            if [[ "${os_type}" == "Darwin" ]]; then
                sed -i "" "s/mysql_ip/${mysql_ip}/g" application.yml
                sed -i "" "s/mysql_port/${mysql_port}/g" application.yml
                sed -i "" "s/mysql_user/${mysql_user}/g" application.yml
                sed -i "" "s/mysql_pwd/${mysql_pwd}/g" application.yml
            else
                sed -i "s/mysql_ip/${mysql_ip}/g" application.yml
                sed -i "s/mysql_port/${mysql_port}/g" application.yml
                sed -i "s/mysql_user/${mysql_user}/g" application.yml
                sed -i "s/mysql_pwd/${mysql_pwd}/g" application.yml
            fi
            cd $pwd/web
            mvn clean package spring-boot:repackage -Dmaven.test.skip=true -U
        '''
    }
}

stage('停止 tomcat') {
    node('master'){
        sh '''
            ## 停止tomcat的函数, 参数$1带入tomcat的路径$TOMCAT_PATH
            killTomcat()
            {
                pid=`ps -ef|grep $1|grep java|awk '{print $2}'`
                echo "tomcat Id list :$pid"
                if [ "$pid" = "" ]
                then
                  echo "no tomcat pid alive"
                else
                  kill -9 $pid
                fi
            }
            ## 停止Tomcat
            killTomcat $tomcat_home
        '''
    }
}

stage('清理环境') {
    node('master'){
        sh '''
            ## 删除原有war包
            rm -f $tomcat_home/webapps/ROOT.war
            rm -rf $tomcat_home/webapps/ROOT
        '''
    }
}

stage('部署新的war包') {
    node('master'){
        sh '''
            cp web/target/web.war $tomcat_home/webapps/
            cd $tomcat_home/webapps
            mv web.war ROOT.war
        '''
    }
}

stage('启动tomcat') {
    node('master'){
        sh '''
            BUILD_ID=DONTKILLME
            cd $tomcat_home/bin
            sh startup.sh
        '''
    }
}