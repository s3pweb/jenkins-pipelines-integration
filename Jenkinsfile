pipeline {
    agent none
    environment {
        dockerImage = ''
        PACKAGE_VERSION = ''
        CI = 'true'
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build & test') {
            agent {
                docker {
                    image 'node:12-alpine'
                }
            }
            steps {
                sh 'npm install'
                sh 'npm run test'
            }
        }
        stage('Docker build - agent any') {
            agent any
            steps {
                script {
                    sh 'npm run docker.build.dev'
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        sh 'npm run docker.push.dev'
                    }
                }
            }
        }
    }
}
