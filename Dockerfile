FROM ubuntu:plucky-20250415 AS build

USER root

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install unzip openjdk-24-jdk

WORKDIR /home/gradle/src
COPY . /home/gradle/src
RUN chmod u+x /home/gradle/src/gradlew
RUN /home/gradle/src/gradlew build --no-daemon

FROM ubuntu:plucky-20250415

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install unzip openjdk-24-jdk

EXPOSE 8080

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

