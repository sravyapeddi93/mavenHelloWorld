node(){
  stage("checkout"){
      checkout scm
    }

    stage("Build"){
        bat "mvn clean compile"
        archiveArtifacts artifacts: '**/target/*.jar'
    }

    stage("Test"){
        bat "mvn run */test/java/AppTest.java"
        junit '*/target/surefire-reports/*.xml'
    }
}
