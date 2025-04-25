FROM ubuntu:noble-20250127 AS build

USER root

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install unzip openjdk-24-jdk

COPY . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build --no-daemon 

FROM ubuntu:noble-20250127

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install unzip openjdk-24-jdk

EXPOSE 8080

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

