FROM openjdk:8-jre


WORKDIR /rmm

COPY worker.jar /rmm/
COPY Server_Config.xml /rmm/


CMD ["java", "-jar", "worker.jar"]

