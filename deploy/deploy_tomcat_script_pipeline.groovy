node('master') {
    stage('同步源码') {
            git([url: 'git@gitee.com:11547299/jeesite4.git', branch: '${branch}'])
    }

    stage('maven编译打包') {
        sh '''
            . ~/.bash_profile
            
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
            
            cd $pwd/root
            mvn clean install -Dmaven.test.skip=true
            
            cd $pwd/web
            mvn clean package spring-boot:repackage -Dmaven.test.skip=true -U
        '''
    }

    stage('停止 tomcat') {
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

    stage('清理环境') {
        sh '''
            ## 删除原有war包
            rm -f $tomcat_home/webapps/ROOT.war
            rm -rf $tomcat_home/webapps/ROOT
        '''
    }

    stage('部署新的war包') {
        sh '''
            cp web/target/web.war $tomcat_home/webapps/
            cd $tomcat_home/webapps
            mv web.war ROOT.war
        '''
    }

    stage('启动tomcat') {
        sh '''
            JENKINS_NODE_COOKIE=dontkillme
            cd $tomcat_home/bin
            sh startup.sh
        '''
    }
}