pipeline {
    agent { docker { image 'python:3.7.0' } }
    stages {
        stage('build') {
            steps {
                bat 'python --version'
            }
        }
    }
}