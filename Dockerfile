#FROM alpine/git
#WORKDIR /app
#RUN git clone https://github.com/VijayalakshmiKumar02/mapit-spring.git

#FROM maven:3.5-jdk-8-alpine
#WORKDIR /app
#COPY --from=0 /app/mapit-spring /app 
#RUN mvn install 



FROM fabric8/java-jboss-openjdk8-jdk:1.2.3
WORKDIR /app
COPY --from=1 app/target/mapit-spring.jar /app 
#ENV JAVA_APP_JAR mapit-spring-0.0.1-SNAPSHOT.jar
#ENV AB_ENABLED off
#ENV AB_JOLOKIA_AUTH_OPENSHIFT true
#ENV JAVA_OPTIONS -Xmx256m 

#EXPOSE 8080

#RUN chmod -R 777 /deployments/
#ADD app/target/mapit-spring-0.0.1-SNAPSHOT.jar /deployments/
