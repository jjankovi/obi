# BUILDER
FROM maven:3.9.2-eclipse-temurin-17 AS builder

ENV HOME=/usr/app
RUN mkdir -p $HOME

WORKDIR $HOME
ADD pom.xml $HOME
RUN mvn verify --fail-never
ADD src $HOME/src
RUN mvn package -Dmaven.test.failure.ignore=true

# APPLICATION
FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY --from=builder /usr/app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]