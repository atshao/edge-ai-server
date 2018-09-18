FROM openjdk:8-jre


WORKDIR /rmm

COPY ota-worker.jar /rmm/
COPY Server_Config.xml /rmm/


CMD ["java", "-jar", "ota-worker.jar"]

