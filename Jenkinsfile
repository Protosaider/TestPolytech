pipeline {
    agent { docker { image 'python:3.6.4' } }
    stages {
        stage('build') {
            steps {
                bat 'python --version'
            }
        }
    }
}