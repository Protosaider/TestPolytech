pipeline {
    //agent { docker { image 'python:3.6.4' } }
    //agent { label 'vs2017' }

    agent none
    
    //environment {
    //	RELEASE_NUMBER = '0.0'
    //	VERSION_NUMBER = VersionNumber(versionNumberString: '0.0.${BUILDS_ALL_TIME}')
    //}

    stages {

    	stage('Checkout from Git')
    	{
    		agent any
    		steps{
    			script {
    				currentBuild.displayName = "#${VERSION_NAME}"
    			}
    			checkout scm
    		}
    	}

    	stage('Nuget package restore')
    	{
    		//agent { label 'nuget'}
    		agent any
    		steps {
    			echo 'Restoring Nuget package'
    			bat '"%NUGET_PATH%" restore App.sln'
    			dir ('.') {
    				stash 'sources'
    			}
    		}
    	}

        stage('build') {
        	//agent { label 'dotNet_4.7'}
        	agent any
            steps {
            	dir ('.') {
            		unstash 'sources'
            	}

                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"

                bat "\"${tool name: 'Default', type: 'msbuild'}\\msbuild.exe\" App.sln /p:Configuration=Release/p:Platform=\"Any CPU\""

                dir ('App/bin') {
                	stash 'bins'
                }            

                bat 'echo %PATH%'
            }
        }

        stage('Archive') {
      		agent any
      		steps {
        		dir ('TestSolution/bin') {
         	 		unstash 'bins'
        		}
        		archive '**/bin/Release/**.dll'
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