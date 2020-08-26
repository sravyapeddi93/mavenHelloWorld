node(){
  stage("checkout"){
      checkout scm
    }

    stage("Build"){
        sh "mvn clean compile"
        archiveArtifacts artifacts: '**/target/*.jar'
    }

    stage("Test"){
        sh "mvn run */test/java/AppTest.java"
        junit '*/target/surefire-reports/*.xml'
    }
}
