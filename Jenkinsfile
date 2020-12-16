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
                }
                timeout(time: 30, unit: 'SECONDS') {
                    script {
                        // Show the select input modal
                       def INPUT_PARAMS = input message: 'Please Provide Parameters', ok: 'Next',
                                        parameters: [choice(name: 'ENVIRONMENT', choices: ["dev-latest","${PACKAGE_VERSION}"].join('\n'), description: 'Please select the Environment')]
                        PACKAGE_VERSION = INPUT_PARAMS.ENVIRONMENT
                    }
                }
                script {
                    dockerImage = docker.build("s3pweb/jenkins-pipeline-integration")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        dockerImage.push("${PACKAGE_VERSION}")
                    }
                }
            }
        }
    }
}
