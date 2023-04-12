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
        stage('Deploy to K8s')
		{
			steps{
				sshagent(['k8s-jenkins'])
				{
					sh 'scp -r -o StrictHostKeyChecking=no train-schedule-kube.yml cloud_user@$control_ip:/tmp'
					script{
						try{
							sh 'ssh cloud_user@$control_ip kubectl apply -f /tmp/train-schedule-kube.yml --kubeconfig=~/.kube/config'
							}catch(error)
							{
							}
					}
				}
			}
		}
    }
}