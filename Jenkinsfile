pipeline {
    //agent { docker { image 'python:3.6.4' } }
    //agent { label 'vs2017' }
    agent any
    
    //environment {
    //	RELEASE_NUMBER = '0.0'
    //	VERSION_NUMBER = VersionNumber(versionNumberString: '0.0.${BUILDS_ALL_TIME}.0')
    //}

    stages {
        stage('build') {
            steps {
            	echo 'Build'
                bat 'python --version'
                bat 'echo %PATH%'
            }
        }
    }
}