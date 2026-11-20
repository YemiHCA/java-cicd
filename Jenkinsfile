

pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = "yemmie69"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/java-cicd"
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                echo 'Source code checked out from GitHub'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('backend') {
                    sh 'pwd'
                    sh 'ls -la'
                    sh 'find src/main/java -type f'
                    sh 'mvn -B clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build \
                    -f Dockerfile \
                    -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                    backend
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKER_TOKEN'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_TOKEN" | docker login \
                        -u "$DOCKERHUB_USERNAME" --password-stdin

                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }
    }
}
