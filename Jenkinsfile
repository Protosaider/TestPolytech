pipeline {
    //agent { docker { image 'python:3.6.4' } }
    //agent { label 'vs2017' }
    agent any
    
    //environment {
    //	RELEASE_NUMBER = '0.0'
    //	VERSION_NUMBER = VersionNumber(versionNumberString: '0.0.${BUILDS_ALL_TIME}.0')
    //}
    node {
        checkout scm
    }

    stages {
        stage('build') {
            steps {
            	echo 'Build'
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                bat 'python --version'
                bat 'echo %PATH%'
            }
        }
    }

    post {
        always {
            echo 'Post message'
        }
        failure {
            echo 'On Failure post-condition'
        }
        success {
            echo 'On Success post-condition'
        }
    }
}