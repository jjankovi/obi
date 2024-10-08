# BUILDER
FROM maven:3.9.2-eclipse-temurin-17 AS builder

ENV HOME=/usr/app
RUN mkdir -p $HOME

WORKDIR $HOME
ADD pom.xml $HOME
RUN mvn verify --fail-never
ADD src $HOME/src
RUN mvn package

# APPLICATION
FROM eclipse-temurin:17-jdk

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws \
    && apt-get clean

RUN aws --version

WORKDIR /app

COPY --from=builder /usr/app/target/*.jar app.jar
COPY paramsloader.sh .
COPY entrypoint.sh .

RUN     set -ex \
        && chmod a+x ./paramsloader.sh \
        && chmod a+x ./entrypoint.sh

EXPOSE 8080
ENTRYPOINT  /app/paramsloader.sh && \
            /app/entrypoint.sh