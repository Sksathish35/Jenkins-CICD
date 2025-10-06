# FROM openjdk:17-jdk-slim
# WORKDIR /app
# COPY target/*.war /app/vprofile.war
# EXPOSE 8080
# CMD ["java", "-jar", "/app/vprofile.war"]


FROM tomcat:10-jdk21
LABEL "Project"="Vprofile"
LABEL "Author"="sathish"

RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
WORKDIR /usr/local/tomcat/
VOLUME /usr/local/tomcat/webapps