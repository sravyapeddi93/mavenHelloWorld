FROM java:8
RUN javac App.java
CMD ["java", "HelloWorld"]