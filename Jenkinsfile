node {
    def gitHubBaseAddress = "github.com"
	def gitLabBaseAddress = "192.168.1.150:10080"
	def gitLabBuildAddress = "${gitLabBaseAddress}/hypercloud/keycloak-distribution.git"
	def kcBuildDir = "/var/lib/jenkins/workspace/hyperauth"
	def imageBuildHome = "${kcBuildDir}/docker"
	
	def gitThemeAddress = "${gitLabBaseAddress}/pk3/tmax-keycloak-theme.git"
	def themeHome = "${kcBuildDir}/themes"
	def scriptHome = "${kcBuildDir}/scripts"
	
	def gitSpiAddress = "${gitHubBaseAddress}/tmax-cloud/hyperauth.git"
	def spiHome = "${kcBuildDir}/spi"

	def version = "${params.majorVersion}.${params.minorVersion}.${params.tinyVersion}.${params.hotfixVersion}"
	def preVersion = "${params.preVersion}"
	
	def imageTag = "b${version}"
	def globalVersion = "HyperAuth-server:b${version}"
				
	def userName = "taegeon_woo"
	def githubUserName = "dnxorjs1"
	def userEmail = "taegeon_woo@tmax.co.kr"

    stage('git pull from keycloak-distribution') {
    	git branch: "${params.buildBranch}",
        credentialsId: '${userName}',
        url: "http://${gitLabBuildAddress}"
    	
    	sh "git checkout ${params.buildBranch}"
		sh "git config --global user.name ${userName}"
		sh "git config --global user.email ${userEmail}"
		sh "git config --global credential.helper store"
    
    	sh "git fetch --all"
		sh "git reset --hard origin/${params.buildBranch}"
		sh "git pull origin ${params.buildBranch}"
    }
    
    stage('git pull from tmax-keycloak-theme') {
    	dir(themeHome){
    	    sh "sudo rm -rf *"
	    	git branch: "${params.themeBranch}",
	        credentialsId: '${userName}',
	        url: "http://${gitThemeAddress}"
	    	sh "git checkout ${params.themeBranch}"
			sh "sudo git config --global user.name ${userName}"
            sh "sudo git config --global user.email ${userEmail}"
			sh "sudo git config --global credential.helper store"
	    
	    	sh "git fetch --all"
			sh "git reset --hard origin/${params.themeBranch}"
			sh "git pull origin ${params.themeBranch}"

            if(type == 'distribution') {
                sh "git tag v${version}"

                sh """
                  echo '# hyperauth tmax theme patch note' > ./CHANGELOG.md
                  echo 'Version: hyperauth tmax theme_v${version}' >> ./CHANGELOG.md
                  date '+%F  %r' >> ./CHANGELOG.md
                  git log --grep=[patch] -F --all-match --no-merges --date-order --reverse \
                  --pretty=format:\"- %s (%cn) %n \" \
                  --simplify-merges v${preVersion}..v${version} \
                  >> ./CHANGELOG.md
                """
                sh "git add -A"
                sh "git commit -m 'build ${version}' "
                sh "sudo git push -u origin +${params.themeBranch}"
                sh "sudo git push origin v${version}"

                sh "git fetch --all"
                sh "git reset --hard origin/${params.themeBranch}"
                sh "git pull origin ${params.themeBranch}"
            }

			sh "sudo rm -f README.md README.txt"
			sh "sudo rm -rf ../docker/tmax/*"
			sh "sudo cp -r tmax/ ../docker/"
            sh "sudo rm -rf ../docker/hypercloud/*"
			sh "sudo cp -r hypercloud/ ../docker/"
            sh "sudo rm -rf ../docker/hyperspace/*"
			sh "sudo cp -r hyperspace/ ../docker/"
			sh "sudo rm -rf ../docker/hyperauth/*"
            sh "sudo cp -r hyperauth/ ../docker/"
            sh "sudo rm -rf ../docker/cnu/*"
            sh "sudo cp -r cnu/ ../docker/"
    	}	
    }
    
    stage('git pull & Maven build from keycloak-spi & git push') {
    	dir(spiHome){
	    	git branch: "${params.spiBranch}",
	        credentialsId: '${githubUserName}',
	        url: "https://${gitSpiAddress}"
	        withMaven(
                maven: 'M353',
                mavenSettingsConfig: 'd8df29f7-3dc7-4506-b839-e2474e4fc051')
            {
                sh "mvn install:install-file -Dfile=lib/com/tmax/tibero/jdbc/6.0/tibero6-jdbc.jar -DgroupId=com.tmax.tibero -DartifactId=jdbc -Dversion=6.0 -Dpackaging=jar -DgeneratePom=true"
                sh "mvn install:install-file -Dfile=lib/com/tmax/hyperauth/server-spi-private/11.0.2/keycloak-server-spi-private-11.0.2.jar -DgroupId=com.tmax.hyperauth -DartifactId=server-spi-private -Dversion=11.0.2 -Dpackaging=jar -DgeneratePom=true"
            }

    	}
    	mavenInstall("${spiHome}", "${globalVersion}")
        dir(spiHome){
            sh "sudo cp -r target/keycloak-spi-jar-with-dependencies.jar ../docker/hyperauth-spi.jar"
            if(type == 'distribution') {
                sh "sudo sh scripts/hyper-auth-changelog.sh ${version} ${preVersion}"
                sh "git checkout ${params.spiBranch}"

                sh "git config --global user.name ${githubUserName}"
                sh "git config --global user.email ${userEmail}"
                sh "git config --global credential.helper store"
                sh "git add -A"

                sh (script:'git commit -m "[SPI] Hyper Auth Server- ${version} " || true')
                sh "git tag v${version}"

                sh "sudo git push -u origin +${params.spiBranch}"
                sh "sudo git push origin v${version}"

                sh "git fetch --all"
                sh "git reset --hard origin/${params.spiBranch}"
                sh "git pull origin ${params.spiBranch}"
            }
        }
    }

    stage('image build & push'){
        if(type == 'distribution') {
            dir(imageBuildHome){
                sh "sudo docker build --tag tmaxcloudck/hyperauth:${imageTag} --build-arg HYPERAUTH_VERSION=${imageTag} ."
                sh "sudo docker tag tmaxcloudck/hyperauth:${imageTag} tmaxcloudck/hyperauth:latest"
                sh "sudo docker push tmaxcloudck/hyperauth:${imageTag}"
                sh "sudo docker push tmaxcloudck/hyperauth:latest"
                sh "sudo docker rmi tmaxcloudck/hyperauth:${imageTag}"
            }
        } else if(type == 'test'){
            dir(imageBuildHome){
                sh "sudo docker build --tag 192.168.9.12:5000/hyperauth-server:b${testVersion} --build-arg HYPERAUTH_VERSION=b${testVersion} ."
                sh "sudo docker push 192.168.9.12:5000/hyperauth-server:b${testVersion}"
                sh "sudo docker rmi 192.168.9.12:5000/hyperauth-server:b${testVersion}"
            }
        }
    }

	if(type == 'distribution') {
        stage('make change log'){
            sh "sudo sh ${scriptHome}/hyper-auth-changelog.sh ${version} ${preVersion}"
        }

        stage('git push'){
            dir ("${kcBuildDir}") {
                sh "git checkout ${params.buildBranch}"

                sh "git config --global user.name ${githubUserName}"
                sh "git config --global user.email ${userEmail}"
                sh "git config --global credential.helper store"
                sh "git add -A"

                sh (script:'git commit -m "[Distribution] Hyper Auth Server- ${version} " || true')
                sh "git tag v${version}"

                sh "sudo git push -u origin +${params.buildBranch}"
                sh "sudo git push origin v${version}"

                sh "git fetch --all"
                sh "git reset --hard origin/${params.buildBranch}"
                sh "git pull origin ${params.buildBranch}"
            }
        }
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



