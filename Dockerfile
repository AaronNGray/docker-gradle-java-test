FROM ubuntu:jammy-20250126 AS build

USER root

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install unzip openjdk-21-jdk

COPY --chown=gradle:gradle . /home/gradle/src
RUN ./gradlew build --no-daemon
WORKDIR /home/gradle/src

FROM ubuntu:jammy-20250126

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install unzip openjdk-21-jdk

EXPOSE 8080

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

