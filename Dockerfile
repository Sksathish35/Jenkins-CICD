FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/*.war /app/vprofile.war
EXPOSE 8080
CMD ["java", "-jar", "/app/vprofile.war"]
