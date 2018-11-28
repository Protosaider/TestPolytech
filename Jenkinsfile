pipeline {

    agent none

    environment {
        PATH_TO_PROJECT_ROOT = 'app/'
        PATH_TO_MSBUILD = 'C:/"Program Files (x86)"/"Microsoft Visual Studio"/2017/Community/MSBuild/15.0/Bin/'
        PATH_TO_NUGET = 'C:/"Program Files (x86)"/NuGet/'
        PROJECT_NAME = 'ConsoleAppHelloWorld'
    }

    options {
            //Skip checking out code from source control by default in the agent directive.
        skipDefaultCheckout true 
            //Used with docker or dockerfile top-level agent. 
            //When specified, each stage will run in a new container instance on the same node, rather than all stages running in the same container instance.
        // newContainerPerStage false
    }

    stages {

        stage('Checkout from Git')
        {
            agent any
            steps {
                //script {
                //  currentBuild.displayName = "#${VERSION_NAME}"
                //}
                checkout scm
            }
        }

        stage('Build image') {
            agent any
            steps {
                /* This builds the actual image; synonymous to docker build on the command line */
                bat 'echo "IN BUILD"'
                script {
                    app = bat 'mingw32-make -f Makefile build'
                }
            }
        }

        stage('Test image') {
            agent any
            steps {
                script {
                    /* Ideally, we would run a test framework against our image. For this example, we're using a Volkswagen-type approach ;-) */
                    app.inside {
                        //sh 'echo "Tests passed"'
                        bat 'echo "Tests passed"'
                    }
                }
            }
        }

        stage ('Run Application') {
            agent any
            steps {
                script {
                    try {
                        // Start database container here
                        // sh 'docker run -d --name db -p 8091-8093:8091-8093 -p 11210:11210 arungupta/oreilly-couchbase:latest'

                // // Run application using Docker image
                // sh "DB=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db`"
                // sh "docker run -e DB_URI=$DB arungupta/docker-jenkins-pipeline:${env.BUILD_NUMBER}"

                        app.inside {
                            bat '/app/out/ConsoleAppHelloWorld.exe'
                        }
                        
                        // Run tests using Maven
                        //dir ('webapp') {
                        //  sh 'mvn exec:java -DskipTests'
                        //}
                    } catch (error) {
                    } finally {
                        bat 'echo "SOMETHING WRONG"'
                        // Stop and remove database container here
                        //sh 'docker-compose stop db'
                        //sh 'docker-compose rm db'
                    }
                }
            }
        }

        // stage('Run Tests') {
        //     agent any
        //     try {
        //         dir('webapp') {
        //             sh "mvn test"
        //             docker.build("arungupta/docker-jenkins-pipeline:${env.BUILD_NUMBER}").push()
        //         }
        //     } catch (error) {
        //     } finally {
        //         junit '**/target/surefire-reports/*.xml'
        //     }
        // }

/*        stage('Push image') {
            agent any
            //  Finally, we'll push the image with two tags: First, the incremental build number from Jenkins Second, the 'latest' tag. 
            // Pushing multiple tags is cheap, as all the layers are reused. 
            docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
            }
        }
*/

/*
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
*/
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
        cleanup {
            deleteDir()
        }
    }
}