pipeline {
    agent any

    stages {
        // stage('Clear Workspace') {
        //     steps {
        //         cleanWs()
        //     }
        // }

        stage("Clone the Repository") {
            agent any
            steps {
                script {
                    // Clone the dev branch
                    git branch: 'dev',url: "https://github.com/ammohan6212/front-end.git"
                    // git branch: 'dev',credentialsId: 'github-token',url: "https://github.com/ammohan6212/front-end.git"

                    // Fetch all tags
                    sh 'git fetch --tags'

                    // Get the latest tag correctly
                    def VERSION = sh(
                        script: "git describe --tags \$(git rev-list --tags --max-count=1)",
                        returnStdout: true
                    ).trim()
                    
                    // Make version available as environment variable
                    env.VERSION = VERSION
                    
                    echo "VERSION=${env.VERSION}"
                }
            }
        }
        stage('get the current application version'){
            steps{
                script{
                    echo "VERSION=${env.version}"
                }
            }
        }
        stage("install the go modules"){
            steps{
                sh '''
                go mod tidy
                '''
            }
        }
        stage("Linting the Code") {
            steps {
                sh '''
                golangci-lint run || true
                '''
            }
        }

        stage("measring the code coverage"){
            steps{
                script(
                    sh 'go test -coverprofile=coverage.out ./...'
                )
            }
        }
        // stage("check the dependecy scanning in go "){
        //     steps{
        //         script{
        //             sh '''


        //                 '''
        //         }

        // }
        stage("Run Unit Tests & Coverage") {
            steps {
                sh '''

                '''
            }
        }
         stage("getting the version in other node"){
             agent { label 'security-agent' }
            steps{
                echo "Using version ${env.VERSION} on node2"
            }
        }     

        stage("trivy and snyk dependecy and code test") {
            steps
        }
        stage("sonar-scanner stage"){
            agent { label 'security-agent' }
            steps{
                script{
                    sh """
                    ls -la
                    /opt/sonar-scanner/bin/sonar-scanner"""
                }
            }

        }
        //  stage("SonarQube Quality Gate") {
        //     steps {
        //         script {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }



        
       stage("Perform Snyk and Trivy Code Analysis") {
            agent { label 'security-agent' }
            steps {
                script {
                 sh '''
                # Authenticate Snyk
                snyk auth 9d262b22-1f2c-4069-adb9-696793789926

                # Run Snyk Code Analysis (for static code issues)
                snyk code test 

                # Run Trivy for OS & library vulnerabilities
                trivy fs . --vuln-type=library --security-checks=vuln --format json --output trivy-vuln.json

                # Run Trivy for secrets
                trivy fs . --scanners secret --format json --output trivy-secrets.json

                # Run full Trivy FS scan
                trivy fs . --format json --output trivy-fs-report.json
            '''
            }
            }
       }


        stage("perform the build"){
            agent { label 'security-agent' }
            steps{
                script{
                    sh '''
                        mkdir build
                        cp -r static/*.html  build/ || true
                        cd build && zip -r frontend-artifact.zip .
                    '''
                }
            }
        }

        stage("Docker Build Stage") {
            agent { label 'security-agent' }
            steps {
                script {
                    echo "VERSION=${env.VERSION}"
                    sh """
                    docker build -t frontend:${env.VERSION} .
                    """
                }
            }
        }
        stage("perform the snyk and trivy image scanning "){
            agent { label 'security-agent' }
            steps{
                script { 
                    sh """
                        ls -l
                        snyk container test frontend:${env.VERSION}  --file=Dockerfile
                        trivy image frontend:${env.VERSION}                 
                    """
                }
                
               
            }
        }
        stage("perform the image scanning using the dockle and Grype"){
            agent { label 'security-agent' }
            steps{
                script{
                    sh """
                    dockle frontend:${env.VERSION}
                    grype frontend:${env.VERSION} > grype-image-scan.txt
                    """
                }
            }
        }
        stage("tagging docker container") {
            agent { label 'security-agent' }
            steps {
                sh """
                docker tag frontend:${env.VERSION} mohan14242/frontend:${env.VERSION}
                """
            }
            
        }
    }
}
