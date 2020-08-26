pipeline{
checkout scm

stages{

stage("Build"){
steps{
sh mvn clean compile
archiveArtifacts artifacts: '**/target/*.jar'
}
}

stage("Test"){
steps{
sh mvn run */test/java/AppTest.java
junit */target/surefire-reports/*.xml
}
}


}
}