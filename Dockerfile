FROM openjdk:17-jdk-alpine
MAINTAINER elpit
COPY target/backend-demo-0.0.1-SNAPSHOT.jar backend-demo-1.0.0.jar
ENTRYPOINT ["java","-jar","/backend-demo-1.0.0.jar"]