pipeline {
    agent any
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
            steps {
                sh 'npm install'
                sh 'npm run test:ci'
            }
        }
        stage('Docker build & push') {
            steps {
                script {
                    PACKAGE_VERSION = sh(
                        script: "echo \$(sed -nE 's/^\\s*\"version\": \"(.*?)\",\$/\\1/p' package.json)",
                        returnStdout: true,
                    )
                }
                timeout(time: 60, unit: 'SECONDS') {
                    script {
                        // Show the select input modal
                       def INPUT_PARAMS = input(
                        message: 'Please provide parameters',
                        ok: 'Next',
                        parameters: [
                            choice(
                                name: 'input',
                                choices: ["dev-latest","${PACKAGE_VERSION}"].join('\n'),
                                description: 'Please select the tag to use')
                        ])
                        PACKAGE_VERSION = INPUT_PARAMS
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
    post {
        always {
            junit skipPublishingChecks: true, testResults: '**/junit.xml'
            cobertura coberturaReportFile: '**/coverage/cobertura-coverage.xml', enableNewApi: true, lineCoverageTargets: '80, 60, 70'
        }
    }
}
