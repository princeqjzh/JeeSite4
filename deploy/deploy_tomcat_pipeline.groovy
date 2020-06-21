stage('同步源码') {
    node('master'){
        git([url: 'git@github.com:princeqjzh/JeeSite4.git', branch: 'master'])
    }
}

