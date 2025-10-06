# FROM openjdk:17-jdk-slim
# WORKDIR /app
# COPY target/*.war /app/vprofile.war
# EXPOSE 8080
# CMD ["java", "-jar", "/app/vprofile.war"]


FROM tomcat:9.0-jdk17
# COPY target/*.war /usr/local/tomcat/webapps/vprofile.war
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
