pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "timolaasonen/train-schedule"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'build/dist/trainSchedule.zip'
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'main'
            }
            environment {
                registryCredential = 'docker_hub_login'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToProduction')
		{
            when {
                branch 'main'
            }
			steps {
                input 'Deploy to Production?'
                milestone(1)
                sshagent(['kubernetes-key']) {
                    sh "envsubst < ./train-schedule-kube.yml > /tmp/train-schedule-kube.yml && scp -o StrictHostKeyChecking=no /tmp/train-schedule-kube.yml cloud_user@18.132.247.26:/home/cloud_user/tmp/ && rm /tmp/train-schedule-kube.yml
                }
            }
		}
    }
}