FROM java:8
EXPOSE 8080
ADD /sravyamaven/target/sravyamaven-1.0-SNAPSHOT.jar /sravyamaven/target/jars/sravyamaven-1.0-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/sravyamaven/target/jars/sravyamaven-1.0-SNAPSHOT.jar"]