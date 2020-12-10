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
                    sh 'npm run docker.push.dev'
                }
            }
        }
    }
}
