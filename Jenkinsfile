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
                withKubeConfig([
                    credentialsId: "	kubeconfig",
                    serverUrl: "https://18.132.248.239"
                ]) {
                    sh 'echo $KUBECONFIG'
                    sh 'cat $KUBECONFIG'

                    //Deploy with Helm
                    echo "Deploying"
                    sh "kubectl get nodes"
                }
            }
		}
    }
}