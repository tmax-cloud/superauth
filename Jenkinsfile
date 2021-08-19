node {
    def gitHubBaseAddress = "github.com"
    def gitSuperAuthAddress = "${gitHubBaseAddress}/tmax-cloud/superauth.git"
	def buildDir = "/var/lib/jenkins/workspace/superauth"
	def scriptHome = "${buildDir}/scripts"
	def version = "${params.majorVersion}.${params.minorVersion}.${params.tinyVersion}.${params.hotfixVersion}"
	def preVersion = "${params.preVersion}"
	def imageTag = "b${version}"
	def globalVersion = "SuperAuth-server:b${version}"
	def githubUserName = "ck-jenkins"
	def userEmail = "taegeon_woo@tmax.co.kr"

    stage('git pull from superauth') {
    	git branch: "${params.buildBranch}",
        credentialsId: '${githubUserName}',
        url: "http://${gitSuperAuthAddress}"

        sh "git checkout ${params.buildBranch}"
        sh "git fetch --all"
        sh "git reset --hard origin/${params.buildBranch}"
        sh "git pull origin ${params.buildBranch}"


    }
    
    stage('Maven build SuperAuth SPI & git push') {
        withMaven(
            maven: 'M353',
            mavenSettingsConfig: 'd8df29f7-3dc7-4506-b839-e2474e4fc051')
        {
            sh "mvn install:install-file -Dfile=lib/com/tmax/tibero/jdbc/6.0/tibero6-jdbc.jar -DgroupId=com.tmax.tibero -DartifactId=jdbc -Dversion=6.0 -Dpackaging=jar -DgeneratePom=true"
            sh "mvn install:install-file -Dfile=lib/com/tmax/superauth/server-spi-private/11.0.2/keycloak-server-spi-private-11.0.2.jar -DgroupId=com.tmax.superauth -DartifactId=server-spi-private -Dversion=11.0.2 -Dpackaging=jar -DgeneratePom=true"
        }
    	mavenInstall("${buildDir}", "${globalVersion}")
    }

    stage('image build & push'){
        if(type == 'distribution') {
            sh "sudo docker build --tag tmaxcloudck/superauth:${imageTag} --build-arg SUPERAUTH_VERSION=${imageTag} ."
            sh "sudo docker tag tmaxcloudck/superauth:${imageTag} tmaxcloudck/superauth:latest"
            sh "sudo docker push tmaxcloudck/superauth:${imageTag}"
            sh "sudo docker push tmaxcloudck/superauth:latest"
            sh "sudo docker rmi tmaxcloudck/superauth:${imageTag}"

        } else if(type == 'test'){
            sh "sudo docker build --tag 192.168.9.12:5000/superauth-server:b${testVersion} --build-arg SUPERAUTH_VERSION=b${testVersion} ."
            sh "sudo docker push 192.168.9.12:5000/superauth-server:b${testVersion}"
            sh "sudo docker rmi 192.168.9.12:5000/superauth-server:b${testVersion}"

        }
    }

	if(type == 'distribution') {
        stage('make change log'){
            sh "sudo sh ${scriptHome}/super-auth-changelog.sh ${version} ${preVersion}"
        }

        stage('git push'){
            sh "git checkout ${params.buildBranch}"
            sh "git add -A"

            sh (script:'git commit -m "[Distribution] Super Auth Server- ${version} " || true')
            sh "git tag v${version}"

            withCredentials([gitUsernamePassword(credentialsId: '${githubUserName}',
                                     gitToolName: 'git-tool')]) {
                sh "sudo git push -u origin +${params.buildBranch}"
                sh "sudo git push origin v${version}"
            }

            sh "git fetch --all"
            sh "git reset --hard origin/${params.buildBranch}"
            sh "git pull origin ${params.buildBranch}"
        }
	}

	stage('clear repo'){
        sh "sudo rm -rf *"
    }
}

void mavenInstall(dirPath,globalVersion) {
    dir (dirPath) {
        withMaven(
        maven: 'M353',
        mavenSettingsConfig: 'd8df29f7-3dc7-4506-b839-e2474e4fc051') {
            sh "mvn clean install -N"
            sh "mvn clean install"
        }
    }
}



