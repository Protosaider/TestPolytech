pipeline {

    agent none
    
    environment {
        PATH_TO_PROJECT_ROOT = 'ConsoleAppHelloWorld/'
        PATH_TO_MSBUILD = 'C:/"Program Files (x86)"/"Microsoft Visual Studio"/2017/Community/MSBuild/15.0/Bin/'
        PATH_TO_NUGET = 'C:/"Program Files (x86)"/NuGet/'
        PROJECT_NAME = 'ConsoleAppHelloWorld'
    }

    stages {

    	stage('Checkout from Git')
    	{
    		agent any
    		steps {
    			//script {
    			//	currentBuild.displayName = "#${VERSION_NAME}"
    			//}
    			checkout scm
    		}
    	}

        stage('Restore Nuget package')
        {
            agent any
            steps {
                echo 'Restoring Nuget package'
                //groovy.lang.MissingPropertyException: No such property: NUGET_PATH for class: groovy.lang.Binding
                //bat ""%NUGET_PATH%" restore ${PATH_TO_PROJECT_ROOT}${PROJECT_NAME}.sln"
                //bat 'nuget restore SolutionName.sln'
                bat "${PATH_TO_NUGET}nuget.exe restore ${PATH_TO_PROJECT_ROOT}${PROJECT_NAME}.sln"
            }
        }

        stage('Build with MSBuild')
        {
            agent any
            steps {
                echo 'Build'
                // Platform="x86" или Platform="x64"
                // ProcessorArchitecture="msil", "x86", "amd64" и "ia64".
                //bat "\"${tool 'MSBuild'}\" SolutionName.sln /p:Configuration=Release /p:Platform=\"Any CPU\" /p:ProductVersion=1.0.0.${env.BUILD_NUMBER}"

                bat "${PATH_TO_MSBUILD}MSBuild.exe ${PATH_TO_PROJECT_ROOT}${PROJECT_NAME}.sln /property:Configuration=Release /property:Platform=\"Any CPU\" /property:ProductVersion=1.0.0.${env.BUILD_NUMBER} /property:OutDir=\"bin/Release\" /property:Utf8Output=true"
            }
        }

        //stage('Archive') {
        //    agent any
        //    steps {
        //        dir ('TestSolution/bin') {
        //            unstash 'bins'
        //        }
        //    archive '**/bin/Release/**.dll'
        //    }
        //}

        //stage ('Archive') {
        //    archive '${PROJECT_NAME}/bin/Release/**'
        //}
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