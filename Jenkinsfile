node()
{
 environment 
    {
        EMAIL_TO = 'someone@host.com'
    }
    def emailOnError() 
    {
      post
      {
        always 
         {
             script 
             {
               if (currentBuild.currentResult == 'FAILURE') 
               {
               step(emailext body: 'Check console output at $BUILD_URL to view the results', 
                    to: "${EMAIL_TO}", 
                    subject: 'Build failed in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER')
               }
             }
         }
      } 
    }
stages
     {
        stage('Initialize')
         {
            steps {
                //enable remote triggers
                script {
                    properties([pipelineTriggers([pollSCM('H/5 * * * *')])])
                }
                //define scm connection for polling
                git branch: master, credentialsId: 'sravyapeddi', url: 'git@github.com:sravyapeddi93/mavenHelloWorld.git'
            }
         }
        stage('Checkout code') 
        {
            steps 
            {
                 checkout scm
            }
        }
        stage('Build') 
        {
            steps 
            {
                 bat 'mvn -b clean package'
                 bat 'echo "Build Completed"'
            }
        }
        stage('UnitTests') 
        {
            steps 
            {
                 bat 'mvn test'
                 junit 'target/surefire-reports/*.xml'
                 bat 'echo "Unit Tests Passes"'
            }
        }
        stage('Install binary file and save it') 
        {
            steps 
            {
                 bat 'mvn install'
                 archiveArtifacts artifacts: 'target/*.jar', onlyIfSuccessful: true
                 bat 'echo "Binary file installed and saved"'
            }
        }
        stage('Copy Archive Binary file') 
        {
            steps 
            {
                 script 
                 {
                 step ([$class: 'CopyArtifact',
                 projectName: 'mavenHelloWorld',
                 filter: "target/*.jar",
                 target: 'Binaryfiles']);
                 }
            }
        }
        stage('Build Docker File') 
        {
            steps 
            {
                 bat 'docker build -f Dockerfile -t sravyadockerdemo'
                 bat 'docker run -p 8080:8080 -t sravyadockerdemo'
                 bat 'echo "Docker file build and run done"'
            }
        }
        stage('Push Image to Docker Hub') 
        {
            steps 
            {
                 bat 'docker push sravyapeddi/sravyadockerrepo:sravyadockerdemo'
                 bat 'echo "Docker Image pushed to DockerHub"'
            }
        }
        stage('Deploy Image to DEV and STAGE') 
        {
            steps 
            {
                 bat 'docker push sravyapeddi/sravyadockerrepo:sravyadockerdemo'
                 bat 'echo "Docker Image pushed to DockerHub"'
            }
        }
        parallel
        {
            stage('Deploy to Dev')
            {
               steps
               {
                  bat 'ecs-deploy -k $AWS_KEY -s $AWS_SECRET -r $AWS_REGION -c $CLUSTER_NAME -n $SERVICE_NAME -i $DOCKER_IMAGE_NAME'
               }
            }
            stage('Deploy to STG')
            {
               steps
               {
                  bat 'ecs-deploy -k $AWS_KEY -s $AWS_SECRET -r $AWS_REGION -c $CLUSTER_NAME -n $SERVICE_NAME -i $DOCKER_IMAGE_NAME'
                  stage('QA Test Execution') 
                  {
                       steps 
                       {
                          build job: 'sravyajenkins', wait: true
                          bat 'echo "QA Execution Completed"'
                       }
                  }
                  
                  if(currentBuild.result = 'SUCCESS')
                  {
                     stage('Writing HTML QA Report') 
                     {
                       steps 
                       {
                          build job: 'sravyajenkins', wait: true
                          bat 'echo "QA Execution Completed"'
                       }
                     }
                  }else
                  {
                    emailOnError()
                  }
               }     
            }       
        }
          
    }
}
