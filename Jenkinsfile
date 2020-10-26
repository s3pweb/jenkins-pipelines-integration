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
                    PACKAGE_VERSION = sh(
                        script: "echo \$(sed -nE 's/^\\s*\"version\": \"(.*?)\",\$/\\1/p' package.json)",
                        returnStdout: true,
                    )
                    dockerImage = docker.build("s3pweb/jenkins-pipeline-integration")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        dockerImage.push("${PACKAGE_VERSION}")
                    }
                }
            }
        }
    }
}
