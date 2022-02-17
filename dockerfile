FROM gradle:6.8.3-jdk11 AS build
ENV APP_HOME=/usr/app/
#COPY . /usr/src/app
WORKDIR $APP_HOME
COPY /src ./
#COPY build.gradle settings.gradle $APP_HOME/
#COPY gradle $APP_HOME/gradle/
COPY --chown=gradle:gradle . $APP_HOME/
USER root
RUN chown -R gradle $APP_HOME
RUN gradle clean build -x test
FROM openjdk:11.0.4-jre-slim
ENV ARTIFACT_NAME=cloud-gateway-0.0.1-SNAPSHOT.jar
ENV APP_HOME=/usr/app/
COPY --from=build $APP_HOME/build/libs/$ARTIFACT_NAME .
EXPOSE 8989

ENTRYPOINT exec java -jar ${ARTIFACT_NAME}