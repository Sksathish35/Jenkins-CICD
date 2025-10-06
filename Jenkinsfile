pipeline{
    
    agent any 
    tools{

        maven "MAVEN"
        jdk "jdk17"
    }
    stages{

        stage('Fetching code from github'){

            steps{
                echo "========executing Fetching code from github========"
                git branch: 'main', url : 'https://github.com/Sksathish35/Jenkins-CICD.git'
                
            }

        }

        stage('Unit test'){
            steps{
                sh 'mvn test'
            }
        }

        stage('Build'){

            steps{
                sh 'mvn install -DskipTests'
            }
            post{
                success{
                    echo "Archiving artifacts"
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage('CODE ANALYSIS with SONARQUBE') {
          
		  environment {
             scannerHome = tool 'sonarqube-scanner-tool'
          }

          steps {
            withSonarQubeEnv('sonarqube') {
               sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
            }

            // timeout(time: 1, unit: 'MINUTES') {
            //    waitForQualityGate abortPipeline: true
            // }
          }
        }

        stage('Build Docker Image') {
            steps {
                script {
                echo "======== Building Docker image ========"
                // Build Docker image using Dockerfile in workspace
                sh """
                docker build -t vprofile-repo:v1.${BUILD_NUMBER} .
                """
                }
                 }
        }

        stage('Push Docker Image to ECR') {
    environment {
        AWS_REGION = 'us-east-1' // replace with your AWS region
        ECR_REPO_NAME = 'vprofile-repo'
        IMAGE_TAG = "v1.${BUILD_NUMBER}" // match your built image tag
        ACCOUNT_ID = '882437028520'      // replace with your AWS Account ID
    }
    steps {
        echo "======== Logging into ECR ========"
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
            sh """
                # Authenticate Docker to ECR
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

                # Tag the existing image with ECR repository URI
                docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}

                # Push the image to ECR
                docker push ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
            """
        }
    }
}
}
}